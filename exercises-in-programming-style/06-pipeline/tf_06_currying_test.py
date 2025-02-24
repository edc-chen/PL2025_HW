import unittest
import tf_06_currying as tf_06

class TestTF06(unittest.TestCase):

    def test_read_file(self):
        path_to_file = "../in.txt"
        excepted = "This is a python test. This test is only a test."
        result = tf_06.read_file(path_to_file)
        self.assertEqual(result, excepted)
    
    def test_filter_chars_and_normalize(self):
        str_data = 'This is a python test. This test is only a test.'
        excepted = 'this is a python test this test is only a test '
        result = tf_06.filter_chars_and_normalize(str_data)
        self.assertEqual(result, excepted)

    def test_scan(self):
        str_data = 'this is a python test this test is only a test '
        excepted = ['this', 'is', 'a', 'python', 'test', 'this', 'test', 'is', 'only', 'a', 'test']
        result = tf_06.scan(str_data)
        self.assertEqual(result, excepted)        

    def test_remove_stop_words(self):
        word_list = ['this', 'is', 'a', 'python', 'test', 'this', 'test', 'is', 'only', 'a', 'test']
        excepted = ['python', 'test', 'test', 'test']
        file_name = '../stop_words.txt'
        result = tf_06.remove_stop_words(word_list)(file_name)
        self.assertEqual(result, excepted)        
    
    def test_frequencies(self):
        word_list = ['python', 'test', 'test', 'test']
        excepted = {'test': 3, 'python': 1}
        result = tf_06.frequencies(word_list)
        self.assertEqual(result, excepted)        
    
    def test_sort(self):
        word_freq = {'test': 3, 'python': 1}
        excepted = [('test', 3), ('python', 1)]
        result = tf_06.sort(word_freq)
        self.assertEqual(result, excepted)        



if __name__ == '__main__':
    unittest.main() 
        