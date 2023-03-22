n = int(input())

answer = format(n, 'b')
length = len("".join(answer.split('0')))

while True:
    n += 1

    if length == len("".join(format(n, 'b').split('0'))):
        print(n)
        break