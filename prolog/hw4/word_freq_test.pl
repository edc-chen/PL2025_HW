:- use_module(library(plunit)).
:- use_module(word_freq).

:- begin_tests(word_freq_test).

test(read_stop_words) :-
    read_stop_words('test_stop_words.txt', StopWords),
    ExpectedWordsPrefix = ["a","is","this","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"],
    assertion(StopWords == ExpectedWordsPrefix).

% 測試文字清洗與正規化
test(filter_chars_and_normalize) :-
    filter_chars_and_normalize("This is a test, only a test....", Result),
    assertion(Result == "this is a test only a test ").

% 測試斷詞功能
test(scan) :-
    scan("this is a test only a test ", Result),
    assertion(Result == ["this","is","a","test","only","a","test"]).

% 測試移除停用詞
test(remove_stop_words) :-
    remove_stop_words(["this","is","a","test","only","a","test"], ["a","is","this"], Result),
    assertion(Result == ["test", "only", "test"]).

% 測試頻率統計
test(frequencies) :-
    frequencies(["test","only","test"], Freq),
    length(Freq, Len),
    assertion(Len =:= 2),
    member("test"-2, Freq),
    member("only"-1, Freq),!.

% 測試排序：給定一個未排序的頻率清單，預期以頻率由大到小排序
test(sorted) :-
    SortedInput = [only-1, test-2],
    sorted(SortedInput, SortedOutput),
    assertion(SortedOutput == [test-2, only-1]).

% 整合測試 word_frequencies/2：

test(word_frequencies) :-
    % 呼叫 word_frequencies/2，這裡用你自備的檔案名稱，請確保它們存在於當前工作目錄中
    with_output_to(string(Output), word_frequencies('test_input.txt', 'test_stop_words.txt')),
    % 根據換行符號切割各行，並排除空行
    split_string(Output, "\n", "\n", Lines0),
    exclude(=( ""), Lines0, Lines),
    % 預期的輸出內容，每一項即一行
    ExpectedLines = [
      "test - 2",      
      "only - 1"      
    ],
    % 檢查內容而非單純格式：這裡直接比對每一行的字串內容
    assertion(Lines == ExpectedLines).

:- end_tests(word_freq_test).