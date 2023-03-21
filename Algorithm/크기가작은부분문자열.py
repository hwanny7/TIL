

def solution(s):
    answer = []
    dic = {}
    for i in range(len(s)):
        if dic.get(s[i]):
            answer.append(i - dic[s[i]])
        else:
            answer.append(-1)
        dic[s[i]] = i + 1

    print(answer)
    return answer
    
s = input()
solution(s)