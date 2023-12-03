class ERD():
    def __init__(self, name, attributes, primaryKey):
        self.name = name
        self.attributes = attributes
        self.primaryKey = primaryKey

    def __str__(self):
        return self.name + "(" + self.attributes + ")" + " PK: " + self.primaryKey


class RelationalSchema():
    def __init__(self, name, attributes, primaryKey, foreignKey):
        self.name = name
        self.attributes = attributes
        self.primaryKey = primaryKey
        self.foreignKey = foreignKey

    def __str__(self):
        return self.name + "(" + self.attributes + ")" + " PK: " + self.primaryKey + " FK: " + self.foreignKey


class Relationship():
    def __init__(self, firstEntity, secondEntity, type):
        self.firstEntity = firstEntity
        self.secondEntity = secondEntity
        self.type = type

    def __str__(self):
        return self.firstEntity + "-" + self.secondEntity + ": " + self.type


def ERDToRelationalSchema(inputPath, outputPath):
    database = []  # Chứa các thực thể của mô hình ERD
    relationships = []  # Chứa mối quan hệ giữa các thực thể của mô hình ERD
    with open(inputPath, 'r') as myInput:
        for line in myInput:
            data = line.split()
            if len(data) == 3:
                database.append(ERD(data[0], data[1], data[2]))
            elif len(data) == 2:
                if '-' not in data[0]:
                    entityName = data[0]
                    attributes = data[1]
                    primaryKey = ""
                    database.append(ERD(entityName, attributes, primaryKey))
                else:
                    entities = data[0].split("-")
                    relationships.append(Relationship(entities[0], entities[1], data[1]))

    resultDatabase = []  # Chứa các bảng dữ liệu
    resultRelationships = []  # Chứa mối quan hệ giữa các bảng

    # Mô hình quan hệ không có mối quan hệ N-N
    for relationship in relationships:
        if (relationship.type == 'N-N'):
            continue
        resultRelationships.append(relationship)

    existed = []  # Chứa tên các bảng đã tồn tại trong mảng resultDatabase, mục đích để không thêm trùng lặp các bảng

    for relationship in relationships:
        for firstEntity in database:
            if relationship.firstEntity == firstEntity.name:

                # Quan hệ 1-1
                if relationship.type == '1-1':
                    # Khoá chính ở phía bắt buộc làm khoá ngoại ở phía tuỳ chọn
                    foreignKey = firstEntity.primaryKey
                    for secondEntity in database:
                        if relationship.secondEntity == secondEntity.name:
                            if firstEntity.name not in existed:
                                resultDatabase.append(RelationalSchema(
                                    firstEntity.name, firstEntity.attributes, firstEntity.primaryKey, ''))
                                existed.append(firstEntity.name)
                            if secondEntity.name not in existed:
                                resultDatabase.append(RelationalSchema(
                                    secondEntity.name, secondEntity.attributes + ',' + foreignKey, secondEntity.primaryKey, foreignKey))
                                existed.append(secondEntity.name)

                # Quan hệ 1-N
                if relationship.type == '1-N':
                    # Khoá chính ở phía quan hệ một làm khoá ngoại ở phía quan hệ nhiều
                    foreignKey = firstEntity.primaryKey
                    for secondEntity in database:
                        if relationship.secondEntity == secondEntity.name:
                            if firstEntity.name not in existed:
                                resultDatabase.append(RelationalSchema(
                                    firstEntity.name, firstEntity.attributes, firstEntity.primaryKey, ''))
                                existed.append(firstEntity.name)

                            if secondEntity.name in existed:  # Trường hợp bảng có nhiều khóa ngoại
                                for entity in resultDatabase:
                                    if (entity.name == secondEntity.name):
                                        entity.attributes += (',' + foreignKey)
                                        entity.foreignKey += (',' + foreignKey)
                                        break
                            else:
                                resultDatabase.append(RelationalSchema(
                                    secondEntity.name, secondEntity.attributes + ',' + foreignKey, secondEntity.primaryKey, foreignKey))
                                existed.append(secondEntity.name)

                # Quan hệ N-N
                elif relationship.type == 'N-N':
                    for secondEntity in database:
                        if relationship.secondEntity == secondEntity.name:
                            print("Đây là mối quan hệ N-N giữa thực thể " +
                                  firstEntity.name + " và thực thể " + secondEntity.name)
                            nameNewTable = input(
                                "Vui lòng nhập tên quan hệ mới được tạo ra từ quan hệ N-N trên: ")
                            attributesNewTable = input(
                                "Vui lòng nhập các thuộc tính muốn thêm cho quan hệ này: ")
                            resultDatabase.append(RelationalSchema(nameNewTable, firstEntity.primaryKey + ',' + secondEntity.primaryKey + ',' + attributesNewTable,
                                                                   firstEntity.primaryKey + ',' + secondEntity.primaryKey, firstEntity.primaryKey + ',' + secondEntity.primaryKey))
                            existed.append(nameNewTable)
                            resultRelationships.append(Relationship(
                                firstEntity.name, nameNewTable, "1-N"))
                            resultRelationships.append(Relationship(
                                secondEntity.name, nameNewTable, "1-N"))
                            if firstEntity.name not in existed:
                                resultDatabase.append(RelationalSchema(
                                    firstEntity.name, firstEntity.attributes, firstEntity.primaryKey, ''))
                                existed.append(firstEntity.name)
                            if secondEntity.name not in existed:
                                resultDatabase.append(RelationalSchema(
                                    secondEntity.name, secondEntity.attributes, secondEntity.primaryKey, ''))
                                existed.append(secondEntity.name)

                # Quan hệ kế thừa
                elif relationship.type == 'Inheritance':
                    # Khoá chính của quan hệ cha trở thành khoá chính của quan hệ con
                    primaryKey = firstEntity.primaryKey
                    for secondEntity in database:
                        if relationship.secondEntity == secondEntity.name:
                            if firstEntity.name not in existed:
                                resultDatabase.append(RelationalSchema(
                                    firstEntity.name, firstEntity.attributes, firstEntity.primaryKey, ''))
                                existed.append(firstEntity.name)
                            if secondEntity.name not in existed:
                                resultDatabase.append(RelationalSchema(
                                    secondEntity.name, secondEntity.attributes + ',' + primaryKey, primaryKey, primaryKey))
                                existed.append(secondEntity.name)
                
                elif relationship.type == "Strong-Weak":
                    foreignKey = firstEntity.primaryKey
                    for secondEntity in database:
                        if secondEntity.name not in existed:
                            resultDatabase.append(RelationalSchema(secondEntity.name,
                                                                    secondEntity.attributes + ',' + foreignKey,
                                                                    secondEntity.primaryKey + ',' + foreignKey,
                                                                    foreignKey))
                            

    myOutput = open(outputPath, 'w')
    for i in range(len(resultDatabase)):
        myOutput.writelines(resultDatabase[i].__str__())
        myOutput.write("\n")

    for relationship in resultRelationships:
        myOutput.writelines(relationship.__str__())
        myOutput.write("\n")


def main():
    ERDToRelationalSchema("input.txt", "output.txt")


if __name__ == "__main__":
    main()