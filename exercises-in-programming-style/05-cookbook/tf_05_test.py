import unittest
import tf_05

class TsetTF05(unittest.TestCase):

    def setUp(self):
        tf_05.data = []        
        tf_05.words = []
        tf_05.word_freqs = []

    def test_read_file(self):
        path_to_file = "../in.txt"
        excepted = list("This is a python test. This test is only a test.")
        tf_05.read_file(path_to_file)
        self.assertEqual(tf_05.data, excepted)
    
    def test_filter_chars_and_normalize(self):
        tf_05.data = list("This is a python test. This test is only a test.")
        excepted = list("this is a python test  this test is only a test ")
        tf_05.filter_chars_and_normalize()
        self.assertEqual(tf_05.data, excepted)
    
    def test_scan(self):
        tf_05.data = list("this is a python test  this test is only a test ")
        excepted = ['this', 'is', 'a', 'python', 'test', 'this', 'test', 'is', 'only', 'a', 'test']
        tf_05.scan()
        self.assertEqual(tf_05.words, excepted)
    
    def test_remove_stop_words(self):
        tf_05.words = ['this', 'is', 'a', 'python', 'test', 'this', 'test', 'is', 'only', 'a', 'test']
        excepted = ['python', 'test', 'test', 'test']
        tf_05.remove_stop_words()
        self.assertEqual(tf_05.words, excepted)

    def test_frequencies(self):
        tf_05.words = ['python', 'test', 'test', 'test']
        excepted = [['python', 1], ['test', 3]]
        tf_05.frequencies()
        self.assertEqual(tf_05.word_freqs, excepted)
    
    def test_sort(self):
        tf_05.word_freqs = [['python', 1], ['test', 3]]
        excepted = [['test', 3], ['python', 1]]
        tf_05.sort()
        self.assertEqual(tf_05.word_freqs, excepted)
    

if __name__ == '__main__':
    unittest.main()

