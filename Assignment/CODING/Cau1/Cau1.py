class ERD:
    def __init__(self, name, attributes, primaryKey):
        self.name = name
        self.attributes = attributes
        self.primaryKey = primaryKey

    def __str__(self):
        return f"{self.name}({self.attributes}) PK: {self.primaryKey}"


class RelationalSchema:
    def __init__(self, name, attributes, primaryKey, foreignKey):
        self.name = name
        self.attributes = attributes
        self.primaryKey = primaryKey
        self.foreignKey = foreignKey

    def __str__(self):
        if self.foreignKey == "":
            return f"{self.name}({self.attributes}) PK:{self.primaryKey}"
        else:
            return f"{self.name}({self.attributes}) PK:{self.primaryKey} FK:{self.foreignKey}"


class Relationship:
    def __init__(self, firstEntity, secondEntity, type):
        self.firstEntity = firstEntity
        self.secondEntity = secondEntity
        self.type = type

    def __str__(self):
        return f"{self.firstEntity}-{self.secondEntity}: {self.type}"


def ERD2RS(inputPath, outputPath):
    Entities = [] # Khởi tạo mảng chứ các thực thể
    Relationships = [] # Khởi tạo mảng chứ các quan hệ giữa các thực thể
    Table = [] # Khởi tạo mảng chứ các table đã được chuyển từ ERD sang RelationalSchema
    AERelationship = [] # Khởi tạo mảng chứ các quan hệ với thực thể kết hợp
    TableExisted = [] # Khởi tạo mảng chứ tên các table đã được khởi tạo

    with open(inputPath, 'r') as myInput:
        for line in myInput:
            data = line.split()
            if len(data) == 3:
                Entities.append(ERD(data[0], data[1], data[2]))
            elif len(data) == 2:
                if '-' not in data[0]:
                    entityName = data[0]
                    attributes = data[1]
                    primaryKey = ""
                    Entities.append(ERD(entityName, attributes, primaryKey))
                else:
                    entities = data[0].split("-")
                    Relationships.append(Relationship(entities[0], entities[1], data[1]))

        for relationship in Relationships:
            for firstEntity in Entities:
                if relationship.firstEntity == firstEntity.name:

                    # Quan hệ 1-1
                    if relationship.type == "1-1":
                        foreignKey = firstEntity.primaryKey
                        for secondEntity in Entities:
                            if relationship.secondEntity == secondEntity.name:
                                if firstEntity.name not in TableExisted:
                                    Table.append(RelationalSchema(firstEntity.name,
                                                                           firstEntity.attributes,
                                                                           firstEntity.primaryKey, ""))
                                    TableExisted.append(firstEntity.name)
                                if secondEntity.name not in TableExisted:
                                    Table.append(RelationalSchema(secondEntity.name,
                                                                           secondEntity.attributes + ',' + foreignKey,
                                                                           secondEntity.primaryKey, foreignKey))
                                    TableExisted.append(secondEntity.name)

                    # Quan hệ 1-N
                    if relationship.type == "1-N":
                        foreignKey = firstEntity.primaryKey
                        for secondEntity in Entities:
                            if relationship.secondEntity == secondEntity.name:
                                if firstEntity.name not in TableExisted:
                                    Table.append(RelationalSchema(firstEntity.name,
                                                                           firstEntity.attributes,
                                                                           firstEntity.primaryKey, ""))
                                    TableExisted.append(firstEntity.name)
                                if secondEntity.name in TableExisted:
                                    for entity in Table:
                                        if entity.name == secondEntity.name:
                                            entity.attributes += ',' + foreignKey
                                            entity.foreignKey += ',' + foreignKey
                                            break
                                else:
                                    Table.append(RelationalSchema(secondEntity.name,
                                                                           secondEntity.attributes + ',' + foreignKey,
                                                                           secondEntity.primaryKey, foreignKey))
                                    TableExisted.append(secondEntity.name)

                    # Quan hệ N-N
                    if relationship.type == 'N-N':
                        for secondEntity in Entities:
                            if relationship.secondEntity == secondEntity.name:
                                print("Đây là mối quan hệ N-N giữa thực thể " +
                                    firstEntity.name + " và thực thể " + secondEntity.name)
                                nameNewTable = input(
                                    "Vui lòng nhập tên quan hệ mới được tạo ra từ quan hệ N-N trên: ")
                                attributesNewTable = input(
                                    "Vui lòng nhập các thuộc tính muốn thêm cho quan hệ này: ")
                                Table.append(RelationalSchema(nameNewTable, firstEntity.primaryKey + ',' + secondEntity.primaryKey + ',' + attributesNewTable,
                                                                    firstEntity.primaryKey + ',' + secondEntity.primaryKey, firstEntity.primaryKey + ',' + secondEntity.primaryKey))
                                TableExisted.append(nameNewTable)
                                AERelationship.append(Relationship(
                                    firstEntity.name, nameNewTable, "1-N"))
                                AERelationship.append(Relationship(
                                    secondEntity.name, nameNewTable, "1-N"))

                    # Quan hệ kế thừa
                    if relationship.type == "Inheritance":
                        primaryKey = firstEntity.primaryKey
                        for secondEntity in Entities:
                            if relationship.secondEntity == secondEntity.name:
                                if firstEntity.name not in TableExisted:
                                    Table.append(RelationalSchema(firstEntity.name,
                                                                           firstEntity.attributes,
                                                                           firstEntity.primaryKey, ""))
                                    TableExisted.append(firstEntity.name)
                                if secondEntity.name not in TableExisted:
                                    Table.append(RelationalSchema(secondEntity.name,
                                                                           secondEntity.attributes + ',' + primaryKey,
                                                                           primaryKey, primaryKey))
                                    TableExisted.append(secondEntity.name)

                    # Quan hệ thực thể mạnh-yếu
                    if relationship.type == "Strong-Weak":
                        foreignKey = firstEntity.primaryKey
                        for secondEntity in Entities:
                            if secondEntity.name not in TableExisted:
                                Table.append(RelationalSchema(secondEntity.name,
                                                                       secondEntity.attributes + ',' + foreignKey,
                                                                       secondEntity.primaryKey + ',' + foreignKey,
                                                                       foreignKey))
                                TableExisted.append(secondEntity.name)

    with open(outputPath, 'w', encoding='utf-8') as myOutput:
        myOutput.write("Các bảng:\n")
        for schema in Table:
            myOutput.write(str(schema) + '\n')

        myOutput.write("\nCác mối quan hệ:\n")
        for relationship in Relationships:
            myOutput.write(str(relationship) + '\n')



ERD2RS("input.txt", "output.txt")
