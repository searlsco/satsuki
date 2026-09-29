import copy
import contextlib
import glob
import importlib.machinery
import importlib.util
import io
import json
import pathlib
import tempfile
import unittest
from unittest.mock import patch

ROOT = pathlib.Path(__file__).resolve().parents[1]
def load_script(name):
    loader = importlib.machinery.SourceFileLoader(name, str(ROOT / "script" / name))
    module = importlib.util.module_from_spec(importlib.util.spec_from_loader(name, loader))
    loader.exec_module(module)
    return module


lint = load_script("lint")
assemble = load_script("assemble")


class SupplementTests(unittest.TestCase):
    def setUp(self):
        self.supplement = json.loads((ROOT / "supplement/patterns.json").read_text())
        self.classes = lint.load(sorted(glob.glob(str(ROOT / "data/*.json"))))

    def check_supplement(self, data):
        with tempfile.TemporaryDirectory() as directory:
            path = pathlib.Path(directory) / "patterns.json"
            path.write_text(json.dumps(data))
            original = lint.SUPPLEMENT
            try:
                lint.SUPPLEMENT = str(path)
                errors = []
                patterns = lint.load_supplement(errors, self.classes)
                return errors, patterns
            finally:
                lint.SUPPLEMENT = original

    def test_supplement_and_existing_senses_have_unambiguous_ranks(self):
        errors, patterns = self.check_supplement(self.supplement)
        lint.check_families(self.classes + patterns, errors, [])
        self.assertEqual(errors, [])
        prohibitive = next(p for p in self.supplement["patterns"] if p["l2_id"] == "S001")
        prohibitive["sense_rank"] = 1
        errors, patterns = self.check_supplement(self.supplement)
        lint.check_families(self.classes + patterns, errors, [])
        self.assertTrue(any("な: sense_rank" in error for error in errors))

    def test_realizations_must_name_an_existing_sense_and_be_unique(self):
        self.supplement["realizations"].append(copy.deepcopy(self.supplement["realizations"][0]))
        self.supplement["realizations"][0]["l2_id"] = "9999"
        self.supplement["realizations"].append(copy.deepcopy(self.supplement["realizations"][-1]))
        errors, _ = self.check_supplement(self.supplement)
        self.assertTrue(any("unknown Tsutsuji l2 ID" in error for error in errors))
        self.assertTrue(any("repeated realization" in error for error in errors))

    def test_undefined_supplement_connection_is_rejected(self):
        self.supplement["patterns"][0]["surfaces"][0]["left_connection"] = "sZ90"
        errors, _ = self.check_supplement(self.supplement)
        self.assertTrue(any("sZ is not defined" in error for error in errors))

    def test_all_examples_strip_ruby_without_losing_written_text(self):
        for pattern in self.supplement["patterns"]:
            for example in pattern["examples"]:
                plain = assemble.strip_ruby(example["ruby"])
                self.assertNotIn("[", plain)
                self.assertNotIn("]", plain)
                self.assertTrue(plain)
        self.assertEqual(assemble.strip_ruby("遅刻[ちこく]すんなよ。"), "遅刻すんなよ。")
        self.assertEqual(assemble.strip_ruby(r"\[例[れい]\]"), "[例]")

    def test_export_preserves_all_original_classes(self):
        with tempfile.TemporaryDirectory() as directory:
            root = pathlib.Path(directory)
            (root / "data").symlink_to(ROOT / "data")
            (root / "supplement").symlink_to(ROOT / "supplement")
            with patch.object(assemble, "REPO", directory), \
                    patch.object(assemble.sys, "argv", ["assemble", "test"]), \
                    contextlib.redirect_stdout(io.StringIO()):
                assemble.main()
            export = json.loads((root / "dist/satsuki-test.json").read_text())
        for cls in export["classes"]:
            for pattern in cls["patterns"]:
                for example in pattern["examples"]:
                    self.assertEqual(example.pop("text"), assemble.strip_ruby(example["ruby"]))
        originals = [json.loads(path.read_text()) for path in sorted((ROOT / "data").glob("*.json"))]
        self.assertEqual(export["classes"], originals)
        self.assertEqual(len(export["supplement"]["patterns"]), 7)
        self.assertEqual(export["supplement"]["patterns"][0]["examples"][1]["text"],
                         "明日の試合、絶対に遅刻すんなよ。")


if __name__ == "__main__":
    unittest.main()
