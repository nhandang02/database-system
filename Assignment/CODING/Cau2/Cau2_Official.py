import copy
import itertools

def cutString(str):
    if '&' in str:
        str = str.split('&')
    else:
        str = [str]
    return str

def findClosure(atri, fds):
    clo = copy.deepcopy(atri)
    temp = []

    while True:
        if clo == temp: 
            break
        temp = copy.deepcopy(clo)
        for i in fds:
            leftAttributes, rightAttributes = i.split('->')
            leftAttributes = cutString(leftAttributes)
            rightAttributes = cutString(rightAttributes)

            check_left = True

            
            for item in leftAttributes:
                if item not in clo:
                    check_left = False
                    break

            if check_left == False:
                continue
            
            for item in rightAttributes:
                if item not in clo:
                    clo.append(item)
    return clo

def Check(item1, item2):
    if len(item1) != len(item2):
        return False
    return sorted(item1) == sorted(item2)

def Subset(relationship):
        subset = []
        for i in range(1, len(relationship)):
            for j in itertools.combinations(relationship, i):
                subset.append(list(j))

        return subset

def findKeys(atri,depend):
    superKeys = []
    subs = Subset(atri)
    for i in subs:
        if Check(atri,findClosure(i,depend)):
            superKeys.append(i)
    
    counter = 0
    results = []
    temp = copy.deepcopy(superKeys)

    while True:
        results = copy.deepcopy(temp)
        for i in range(counter,len(temp)):
            for j in range(counter + 1,len(temp)):
                ischild = True
                for item in temp[i]:
                    if item not in temp[j]:
                        ischild = False
                        break
                if ischild == True and temp[j] in results:
                    results.remove(temp[j])
            break
        if results == temp:
            break
        counter = counter + 1 
        temp = copy.deepcopy(results)

    return results

def readFile(filename):
    f = open(filename,"r")
    lines = f.readlines()
    dict = {}
    for line in lines:
        temp = line.split(' ')
        dict.setdefault(temp[0])
        dict[temp[0]] = [temp[1],temp[2].replace("\n","")]
    f.close()
    return dict

input_User = input("Nhập vào tập thuộc tính X cần tính bao đóng nếu trên 2 thuộc tính thì chúng cách nhau bằng dấu (&): ")
User_input = input_User.split("&")
dict = readFile("input2.txt")
set1 = set(User_input)
check = False
temp = ""
for i in dict:
    atribute = dict[i][0].split(",")
    dependent = dict[i][1].split(",")
    set2 = set(atribute)
    if set1.issubset(set2):
        check = True
        temp = i
        break
if(check == False):
    print("Các dữ liệu bạn truyền vào không có trong các bảng trong file input")
    exit()

closure = findClosure(User_input, dependent)
keys = findKeys(atribute, dependent)

def writeFile(dict):
    file = open("output2.txt", "w", encoding="utf-8")
    file.write("Bảng: " + temp + "\n")
    file.write("Bao đóng của tập X nhập vào : " + ",".join(closure) + "\n")
    file.write("Các khóa: ")
    for i in keys:
        file.write("".join(i) + "," )
    

dict = readFile('input2.txt')
writeFile(dict)
