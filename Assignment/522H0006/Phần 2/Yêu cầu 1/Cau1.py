# Tạo các lớp
class ERD:
    def __init__(self, entityName, attributes, primaryKey):
        self.entityName = entityName
        self.attributes = attributes
        self.primaryKey = primaryKey

    def __str__(self):
        return f"{self.entityName}({self.attributes}) PK: {self.primaryKey}"

class RelationalSchema:
    def __init__(self, tableName, attributes, primaryKey, foreignKey):
        self.tableName = tableName
        self.attributes = attributes
        self.primaryKey = primaryKey
        self.foreignKey = foreignKey

    def __str__(self):
        if self.foreignKey == "":
            return f"{self.tableName}({self.attributes}) PK:{self.primaryKey}"
        else:
            return f"{self.tableName}({self.attributes}) PK:{self.primaryKey} FK:{self.foreignKey}"

class Relationship:
    def __init__(self, firstEntity, secondEntity, typeRelationship):
        self.firstEntity = firstEntity
        self.secondEntity = secondEntity
        self.typeRelationship = typeRelationship

    def __str__(self):
        return f"{self.firstEntity}-{self.secondEntity}: {self.typeRelationship}"

# Chuyển đổi mô hình ERD sang mô hình quan hệ
def ERDToRelationalSchema(inputPath, outputPath):
    entities = []  # Chứa các thực thể của mô hình ERD
    relationships = []  # Chứa mối quan hệ giữa các thực thể của mô hình ERD
    tables = []  # Chứa các bảng dữ liệu
    tableExisted = []  # Chứa tên các bảng đã tồn tại trong mảng tables, mục đích để không thêm trùng lặp các bảng

    # Đọc dữ liệu từ file input
    with open(inputPath, 'r') as myInput:
        for line in myInput:
            data = line.split()
            if len(data) == 3:
                entities.append(ERD(data[0], data[1], data[2]))
            elif len(data) == 2:
                if '-' not in data[0]:
                    entityName = data[0]
                    attributes = data[1]
                    primaryKey = ""
                    entities.append(ERD(entityName, attributes, primaryKey))
                else:
                    object = data[0].split("-")
                    relationships.append(Relationship(object[0], object[1], data[1]))


    # Xử lí các mối quan hệ
    for relationship in relationships:
        for firstEntity in entities:
            if relationship.firstEntity == firstEntity.entityName:

                # Quan hệ 1-1
                if relationship.typeRelationship == '1-1':
                    foreignKey = firstEntity.primaryKey
                    for secondEntity in entities:
                        if relationship.secondEntity == secondEntity.entityName:
                            if firstEntity.entityName not in tableExisted:
                                tables.append(RelationalSchema(
                                    firstEntity.entityName, firstEntity.attributes, firstEntity.primaryKey, ''))
                                tableExisted.append(firstEntity.entityName)
                            if secondEntity.entityName not in tableExisted:
                                tables.append(RelationalSchema(
                                    secondEntity.entityName, secondEntity.attributes + ',' + foreignKey, secondEntity.primaryKey, foreignKey))
                                tableExisted.append(secondEntity.entityName)

                # Quan hệ 1-N
                if relationship.typeRelationship == '1-N':
                    foreignKey = firstEntity.primaryKey
                    for secondEntity in entities:
                        if relationship.secondEntity == secondEntity.entityName:
                            if firstEntity.entityName not in tableExisted:
                                tables.append(RelationalSchema(
                                    firstEntity.entityName, firstEntity.attributes, firstEntity.primaryKey, ''))
                                tableExisted.append(firstEntity.entityName)

                            if secondEntity.entityName in tableExisted: 
                                for entity in tables:
                                    if (entity.entityName == secondEntity.entityName):
                                        entity.attributes += (',' + foreignKey)
                                        entity.foreignKey += (',' + foreignKey)
                                        break
                            else:
                                tables.append(RelationalSchema(
                                    secondEntity.entityName, secondEntity.attributes + ',' + foreignKey, secondEntity.primaryKey, foreignKey))
                                tableExisted.append(secondEntity.entityName)

                # Quan hệ N-N
                if relationship.typeRelationship == 'N-N':
                    for secondEntity in entities:
                        if relationship.secondEntity == secondEntity.entityName:
                            print("Đây là mối quan hệ N-N giữa thực thể " +
                                  firstEntity.entityName + " và thực thể " + secondEntity.entityName)
                            nameNewTable = input(
                                "Vui lòng nhập tên quan hệ mới được tạo ra từ quan hệ N-N trên: ")
                            attributesNewTable = input(
                                "Vui lòng nhập các thuộc tính muốn thêm cho quan hệ này: ")
                            tables.append(RelationalSchema(nameNewTable, firstEntity.primaryKey + ',' + secondEntity.primaryKey + ',' + attributesNewTable,
                                                                   firstEntity.primaryKey + ',' + secondEntity.primaryKey, firstEntity.primaryKey + ',' + secondEntity.primaryKey))
                            tableExisted.append(nameNewTable)
        
                            if firstEntity.entityName not in tableExisted:
                                tables.append(RelationalSchema(
                                    firstEntity.entityName, firstEntity.attributes, firstEntity.primaryKey, ''))
                                tableExisted.append(firstEntity.entityName)
                            if secondEntity.entityName not in tableExisted:
                                tables.append(RelationalSchema(
                                    secondEntity.entityName, secondEntity.attributes, secondEntity.primaryKey, ''))
                                tableExisted.append(secondEntity.entityName)

                # Quan hệ kế thừa
                if relationship.typeRelationship == 'Inheritance':
                    # Khoá chính của quan hệ cha trở thành khoá chính của quan hệ con
                    primaryKey = firstEntity.primaryKey
                    for secondEntity in entities:
                        if relationship.secondEntity == secondEntity.entityName:
                            if firstEntity.entityName not in tableExisted:
                                tables.append(RelationalSchema(
                                    firstEntity.entityName, firstEntity.attributes, firstEntity.primaryKey, ''))
                                tableExisted.append(firstEntity.entityName)
                            if secondEntity.entityName not in tableExisted:
                                tables.append(RelationalSchema(
                                    secondEntity.entityName, secondEntity.attributes + ',' + primaryKey, primaryKey, primaryKey))
                                tableExisted.append(secondEntity.entityName)
                
                # Quan hệ thực thể mạnh yếu
                if relationship.typeRelationship == "Strong-Weak":
                    foreignKey = firstEntity.primaryKey
                    for secondEntity in entities:
                        if relationship.secondEntity == secondEntity.entityName:
                            if secondEntity.entityName not in tableExisted:
                                tables.append(RelationalSchema(secondEntity.entityName,
                                                                        secondEntity.attributes + ',' + foreignKey,
                                                                        secondEntity.primaryKey + ',' + foreignKey,
                                                                        foreignKey))
                                tableExisted.append(secondEntity.entityName)          

    # Viết kết quả vào file output
    with open(outputPath, 'w', encoding='utf-8') as myOutput:
        myOutput.write("Các bảng:\n")
        for schema in tables:
            myOutput.write(str(schema) + '\n')

        myOutput.write("\nCác mối quan hệ:\n")
        for relationship in relationships:
            myOutput.write(str(relationship) + '\n')

ERDToRelationalSchema("input1.txt", "output1.txt")