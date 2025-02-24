import unittest
import tf_05

class TsetTF05(unittest.TestCase):
    def test_read_file(self):
        tf_05.read_file('input.txt')
        self.assertEqual(tf_05.data, list(''.join(open('input.txt').readlines())))
    
    def test_filter_chars_and_normalize(self):
        tf_05.read_file('input.txt')
        tf_05.filter_chars_and_normalize()
        for i in range(len(tf_05.data)):
            if tf_05.data[i] not in tf_05.letters:
                self.assertEqual(tf_05.data[i], ' ')
            else:
                self.assertEqual(tf_05.data[i], tf_05.data[i].lower())
    
    def test_scan(self):
        tf_05.read_file('input.txt')
        tf_05.filter_chars_and_normalize()
        tf_05.scan()
        self.assertEqual(tf_05.words, open('input.txt').read().lower().split())
    
    def test_remove_stop_words(self):
        tf_05.read_file('input.txt')
        tf_05.filter_chars_and_normalize()
        tf_05.scan()
        tf_05.remove_stop_words()
        with open('../stop_words.txt') as f:
            stop_words = f.read().split(',')
        stop_words.extend(list(tf_05.string.ascii_lowercase))
        for w in tf_05.words:
            self.assertNotIn(w, stop_words)
    
    def test_frequencies(self):
        tf_05.read_file('input.txt')
        tf_05.filter_chars_and_normalize()
        tf_05.scan()
        tf_05.remove_stop_words()
        tf_05.frequencies()
        for w in tf_05.words:
            self.assertIn(w, [wd[0] for wd in tf_05.word_freqs])
    
    def test_sort(self):
        tf_05.read_file('input.txt')
        tf_05.filter_chars_and_normalize()
        tf_05.scan()
        tf_05.remove_stop_words()
        tf_05.frequencies()
        tf_05.sort()
        for i in range(len(tf_05.word_freqs) - 1):
            self.assertGreaterEqual(tf_05.word_freqs[i][1], tf_05.word_freqs[i + 1][1])

if __name__ == '__main__':
    unittest.main()

