import tf_05

sentence = "This is a python test. This test is only a test."
tf_05.read_file("../in.txt")
tf_05.filter_chars_and_normalize()
tf_05.scan()
print(tf_05.words)