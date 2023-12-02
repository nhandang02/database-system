import itertools

# Exercise 2


def convertFDSetToString(elements):
    return "{{{}}}".format(", ".join(sorted([str(element) for element in elements])))


def convertSetToString(set):
    return "".join(attribute for attribute in set)


def convertStringToSet(str):
    attributes = str.split(",")
    result = set()
    for attribute in attributes:
        result.add(attribute)
    return result


def sortString(str):
    return ''.join(sorted(str))


class FunctionalDependency:

    def __init__(self, lhs, rhs):
        self.lhs = lhs
        self.rhs = rhs

    def __str__(self):
        return "{} -> {}".format(convertSetToString(self.lhs), convertSetToString(self.rhs))


class FDSet(set):

    def __init__(self):
        set.__init__(self)

    def __str__(self):
        return convertFDSetToString(self)

    def setOfAttributesInLeftHandSide(self):
        result = set()
        for fd in self:
            result.update(fd.lhs)
        return result

    def setOfAttributesInRightHandSide(self):
        result = set()
        for fd in self:
            result.update(fd.rhs)
        return result

    # Tìm bao đóng của tập thuộc tính
    def closureOfAttributeSet(self, attributes):
        result = set(attributes)
        stillChange = True
        while stillChange:
            stillChange = False
            for fd in self:
                if fd.lhs.issubset(result) and not fd.rhs.issubset(result):
                    stillChange = True
                    result.update(fd.rhs)
        return result

    # Tìm các khóa
    def keys(self, attributes):
        N = attributes.difference(self.setOfAttributesInRightHandSide())
        if convertSetToString(self.closureOfAttributeSet(N)) == convertSetToString(attributes):
            return convertSetToString(N)
        D = self.setOfAttributesInRightHandSide().difference(
            self.setOfAttributesInLeftHandSide())
        L = attributes.difference(N.union(D))
        powerSet = []
        for i in range(len(L)):
            for element in list(itertools.combinations(L, i + 1)):
                powerSet.append(element)
        result = []
        listLiIsKey = []
        for Li in powerSet:
            isKey = False
            Li = set(Li)
            for element in listLiIsKey:
                if element.issubset(Li):
                    isKey = True
            if (isKey):
                continue
            X = N.union(Li)
            if sortString(convertSetToString(self.closureOfAttributeSet(convertSetToString(X)))) == sortString(convertSetToString(attributes)):
                result.append(X)
                listLiIsKey.append(Li)
        for i in range(len(result)):
            result[i] = convertSetToString(result[i])
        return result


class Relation():
    def __init__(self):
        self.name = ""
        self.attributes = ""
        self.fdSet = FDSet()


def countLinesInFile(filePath):
    count = 0
    myFile = open(filePath, "r")
    lines = myFile.readlines()
    for line in lines:
        count += 1
    return count


def loadFile(filePath):
    relations = []
    for i in range(countLinesInFile(filePath)):
        relations.append(Relation())
    myInput = open(filePath, "r")
    lines = myInput.readlines()
    i = 0
    for line in lines:
        data = line.rstrip('\n').split(" ")
        relations[i].name = data[0]
        relations[i].attributes = data[1]
        fdSet = data[2].split(";")
        for fd in fdSet:
            relations[i].fdSet.add(FunctionalDependency(convertStringToSet(fd.split(
                "_")[0]), convertStringToSet(fd.split("_")[1])))
        i += 1
    return relations


def writeToFile(filePath, relations, X):
    myOutput = open(filePath, "w")
    for relation in relations:
        myOutput.writelines(convertSetToString(relation.fdSet.closureOfAttributeSet(X)) + " " + ','.join(relation.fdSet.keys(
            convertStringToSet(relation.attributes))))
        myOutput.write("\n")


def main():
    X = input("Enter attribute set X: ").rstrip('\n')
    relations = loadFile("input2.txt")
    writeToFile("output2.txt", relations, X)


if __name__ == "__main__":
    main()