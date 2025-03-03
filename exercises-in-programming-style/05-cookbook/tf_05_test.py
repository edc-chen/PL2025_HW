import unittest
import tf_05
import copy

class TsetTF05(unittest.TestCase):

    def setUp(self):
        tf_05.data = []        
        tf_05.words = []
        tf_05.word_freqs = []

    def test_read_file(self):
        '''
        non-idempotent
        因為每次呼叫都會把讀取的資料加到全域變數data，所以會有重複的動作，屬於 non-idempotent。
        '''
        path_to_file = "../in.txt"

        tf_05.read_file(path_to_file)
        first = tf_05.data.copy()
        tf_05.read_file(path_to_file)
        second = tf_05.data.copy()
        self.assertEqual(first, second)
    
    def test_filter_chars_and_normalize(self):
        '''
        idempotent
        每次操作都是過濾固定字符重複多次都是對同樣的字符進行篩選，所以不會有重複的動作，屬於 idempotent。
        '''
        tf_05.data = list("This is a python test. This test is only a test.")

        tf_05.filter_chars_and_normalize()
        first = tf_05.data.copy()
        tf_05.filter_chars_and_normalize()
        second = tf_05.data.copy()
        self.assertEqual(first, second)
    
    def test_scan(self):
        '''
        non-idempotent
        因為每次呼叫都會把符合的字詞加到全域變數words並且未清空初始化，所以會有重複的動作，屬於 non-idempotent。
        '''
        tf_05.data = list("this is a python test  this test is only a test ")
        
        tf_05.scan()
        first = tf_05.words.copy()
        tf_05.scan()
        second = tf_05.words.copy()
        self.assertEqual(first, second)
    
    def test_remove_stop_words(self):
        '''
        idempotent
        因為每次呼叫都會把符合的字詞移除，所以不會有重複的動作，屬於 idempotent。
        '''
        tf_05.words = ['this', 'is', 'a', 'python', 'test', 'this', 'test', 'is', 'only', 'a', 'test']
        
        tf_05.remove_stop_words()
        first = tf_05.words.copy()
        tf_05.remove_stop_words()
        second = tf_05.words.copy()
        self.assertEqual(first, second)

    def test_frequencies(self):
        '''
        non-idempotent 
        他會重複計算因為沒有清空全域變數word_freqs，所以每次呼叫都會把結果 append 進去，屬於 non-idempotent。
        '''
        tf_05.words = ['python', 'test', 'test', 'test']
        
        tf_05.frequencies()
        first = copy.deepcopy(tf_05.word_freqs)
        tf_05.frequencies()
        second = copy.deepcopy(tf_05.word_freqs)
        self.assertEqual(first, second)

    def test_sort(self):
        '''
        idempotent
        雖然一樣使用全域變數但是因為是排序再重複排列多少次都一樣，屬於 idempotent。
        '''
        tf_05.word_freqs = [['python', 1], ['test', 3]]
        
        tf_05.sort()        
        first = tf_05.word_freqs.copy()
        tf_05.sort()
        second = tf_05.word_freqs.copy()
        self.assertEqual(first, second)
    

if __name__ == '__main__':
    unittest.main()

