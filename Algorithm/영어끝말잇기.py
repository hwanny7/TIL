words = ["hello", "observe", "effect", "take", "either", "recognize", "encourage", "ensure", "establish", "hang", "gather", "refer", "reference", "estimate", "executive"]
n = 5

for i in range(1, len(words)):
    if not words[i][0] == words[i - 1][-1] or words[i] in words[:i - 1]:
        number = n if not (i + 1) % n else (i + 1) % n
        print([number, (i + 1) // number])
else:
    print([0, 0])