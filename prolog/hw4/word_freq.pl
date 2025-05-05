:- use_module(library(apply)).        % maplist/3
:- use_module(library(readutil)).     % read_line_to_string/2
:- use_module(library(pcre)).        % pcre_replace/4
:- use_module(library(lists)).      % 提供列表操作
:- use_module(library(yall)).  % 載入 lambda 支援


read_stop_words(File, StopWords) :-
    open(File, read, Stream),
    read_line_to_string(Stream, Line),
    close(Stream),
    % 以逗號分隔
    split_string(Line, ",", "", StopWordsStr),
    % 轉小寫並去除空字串
    maplist(string_lower, StopWordsStr, Lower0),
    exclude(=([]), Lower0, FilteredWords),
    % 產生單一字母 a–z 的 string 列表
    findall(Letter,
            ( between(0,25,I),
              C is 0'a + I,
              char_code(Char, C),
              string_chars(Letter, [Char])
            ),
            Letters),    
    append(FilteredWords, Letters, StopWords).

filter_chars_and_normalize(Text, Result) :-
    re_replace('[\\W_]+'/g, ' ', Text, TempResult),
    string_lower(TempResult, Result).

scan(Text, Words) :-
    % 首先去除字串前後的空白（符合 '^\\s+|\\s+$' 的部分）
    re_replace('^\\s+|\\s+$', "", Text, Trimmed),
    % 接著以 " " 作為分隔符號分割 Trimmed 字串，
    % 第四個參數 "" 表示在切割後不做進一步的修剪，這樣可以保留連續空白所產生的空字串
    split_string(Trimmed, " ", "", Words).

% remove_stop_words(+WordList, +StopWords, -FilteredWordList)
remove_stop_words(WordList, StopWords, FilteredWordList) :-
    include({StopWords}/[Word]>>( \+ member(Word, StopWords) ), WordList, FilteredWordList).

frequencies(WordList, WordFreq) :-
    foldl(
        % Lambda 表達式，將 W 添加到累加器 Acc
        {}/[W, Acc, NewAcc]>>(
            ( select(W-Count, Acc, Rest) ->
                NewCount is Count + 1,
                NewAcc = [W-NewCount|Rest]
            ;
                NewAcc = [W-1|Acc]
            )
        ),
        WordList, [], WordFreq
    ).

sorted(WordList, SortedWordList) :-
    predsort(
        {}/[Order, W1-C1, W2-C2] >> (
            ( C1 =:= C2 ->
                % 當頻率相同時，利用字母順序作 tie-breaker
                compare(Order, W1, W2)
            ;
                % 否則，根據頻率作降序排序：較大的頻率排在前面
                compare(Order, C2, C1)
            )
        ),
        WordList,
        SortedWordList
    ).


% 主函式：讀取主檔案與停用詞檔案，計算詞頻，並輸出前 25 筆結果，每行格式為 "word - count"
word_frequencies(File, StopWordsFile) :-
    read_file_to_string(File, Text, []),
    read_stop_words(StopWordsFile, StopWords),
    filter_chars_and_normalize(Text, NormalizedText),
    scan(NormalizedText, WordList),
    remove_stop_words(WordList, StopWords, FilteredWordList),
    frequencies(FilteredWordList, WordFreq),
    sorted(WordFreq, SortedWordList),
    % 若筆數 ≥ 25，取前 25 筆；否則全部輸出,為了測試方便，這裡需要有變通能力
    (   length(SortedWordList, L),
        L >= 25 ->
        length(TopWords, 25),
        append(TopWords, _, SortedWordList)
    ;   TopWords = SortedWordList
    ),
    % 將結果格式化輸出，每筆以 "word - count" 的格式
    maplist({}/[Word-Count]>>format('~w - ~w~n', [Word, Count]), TopWords).