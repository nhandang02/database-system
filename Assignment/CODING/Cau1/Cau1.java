import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.*;

class ERD {
    String name;
    String attributes;
    String primaryKey;

    public ERD(String name, String attributes, String primaryKey) {
        this.name = name;
        this.attributes = attributes;
        this.primaryKey = primaryKey;
    }

    public String toString() {
        return this.name + "(" + this.attributes + ")" + " PK: " + this.primaryKey;
    }
}

class RelationalSchema {
    String name;
    String attributes;
    String primaryKey;
    String foreignKey;

    public RelationalSchema(String name, String attributes, String primaryKey, String foreignKey) {
        this.name = name;
        this.attributes = attributes;
        this.primaryKey = primaryKey;
        this.foreignKey = foreignKey;
    }

    public String toString() {
        String result;
        if (this.foreignKey == "")
            result = this.name + "(" + this.attributes + ")" + " PK: " + this.primaryKey;
        else
            result = this.name + "(" + this.attributes + ")" + " PK: " + this.primaryKey + " FK: " + this.foreignKey;
        return result;
    }
}

class Relationship {
    String firstEntity;
    String secondEntity;
    String type;

    public Relationship(String firstEntity, String secondEntity, String type) {
        this.firstEntity = firstEntity;
        this.secondEntity = secondEntity;
        this.type = type;
    }

    public String toString() {
        return this.firstEntity + "-" + this.secondEntity + ": " + this.type;
    }
}

class ERD2RS {
    public static void ERDToRelationalSchema(String inputPath, String outputPath) {
        List<ERD> database = new ArrayList<>();
        List<Relationship> relationships = new ArrayList<>();
        List<RelationalSchema> resultDatabase = new ArrayList<>();
        List<Relationship> resultRelationships = new ArrayList<>();
        List<String> existed = new ArrayList<>();

        try (BufferedReader myInput = new BufferedReader(new FileReader(inputPath))) {
            String line;
            while ((line = myInput.readLine()) != null) {
                String[] data = line.split(" ");
                if (data.length == 3) {
                    database.add(new ERD(data[0], data[1], data[2]));
                } else if (data.length == 2) {
                    if (!data[0].contains("-")) {
                        // Nếu không có dấu '-' thì đây là thực thể con
                        String entityName = data[0];
                        String attributes = data[1];
                        String primaryKey = "ID"; // Giả sử primaryKey của thực thể con là "ID"
                        database.add(new ERD(entityName, attributes, primaryKey));
                    } else {
                        String[] entities = data[0].split("-");
                        relationships.add(new Relationship(entities[0], entities[1], data[1]));
                    }
                }
            }

            for (Relationship relationship : relationships) {
                for (ERD firstEntity : database) {
                    if (relationship.firstEntity.equals(firstEntity.name)) {

                        // Quan hệ 1-1
                        if (relationship.type.equals("1-1")) {
                            // Khoá chính ở phía bắt buộc làm khoá ngoại ở phía tuỳ chọn
                            String foreignKey = firstEntity.primaryKey;
                            for (ERD secondEntity : database) {
                                if (relationship.secondEntity.equals(secondEntity.name)) {
                                    if (!existed.contains(firstEntity.name)) {
                                        resultDatabase.add(new RelationalSchema(firstEntity.name,
                                                firstEntity.attributes, firstEntity.primaryKey, ""));
                                        existed.add(firstEntity.name);
                                    }
                                    if (!existed.contains(secondEntity.name)) {
                                        resultDatabase.add(new RelationalSchema(secondEntity.name,
                                                secondEntity.attributes + ',' + foreignKey,
                                                secondEntity.primaryKey, foreignKey));
                                        existed.add(secondEntity.name);
                                    }
                                }
                            }
                        }

                        // Quan hệ 1-N
                        if (relationship.type.equals("1-N")) {
                            // Khoá chính ở phía quan hệ một làm khoá ngoại ở phía quan hệ nhiều
                            String foreignKey = firstEntity.primaryKey;
                            for (ERD secondEntity : database) {
                                if (relationship.secondEntity.equals(secondEntity.name)) {
                                    if (!existed.contains(firstEntity.name)) {
                                        resultDatabase.add(new RelationalSchema(firstEntity.name,
                                                firstEntity.attributes, firstEntity.primaryKey, ""));
                                        existed.add(firstEntity.name);
                                    }
                                    if (existed.contains(secondEntity.name)) {
                                        // Trường hợp bảng có nhiều khóa ngoại
                                        for (RelationalSchema entity : resultDatabase) {
                                            if (entity.name.equals(secondEntity.name)) {
                                                entity.attributes += (',' + foreignKey);
                                                entity.foreignKey += (',' + foreignKey);
                                                break;
                                            }
                                        }
                                    }
                                    if (!existed.contains(secondEntity.name)) {
                                        resultDatabase.add(new RelationalSchema(secondEntity.name,
                                                secondEntity.attributes + ',' + foreignKey,
                                                secondEntity.primaryKey, foreignKey));
                                        existed.add(secondEntity.name);
                                    }
                                }
                            }
                        }

                        // Quan hệ N-N
                        else if (relationship.type.equals("N-N")) {
                            for (ERD secondEntity : database) {
                                if (relationship.secondEntity.equals(secondEntity.name)) {
                                    System.out.println("This is an N-N relationship between entities  " +
                                            firstEntity.name + " and " + secondEntity.name);
                                    String nameNewTable = System.console().readLine(
                                            "Enter the name for the new relationship table: ");
                                    String attributesNewTable = System.console().readLine(
                                            "Enter attributes for the new table: ");
                                    resultDatabase.add(new RelationalSchema(nameNewTable,
                                            firstEntity.primaryKey + ',' + secondEntity.primaryKey + ','
                                                    + attributesNewTable,
                                            firstEntity.primaryKey + ',' + secondEntity.primaryKey,
                                            firstEntity.primaryKey + ',' + secondEntity.primaryKey));
                                    existed.add(nameNewTable);
                                    resultRelationships.add(new Relationship(
                                            firstEntity.name, nameNewTable, "1-N"));
                                    resultRelationships.add(new Relationship(
                                            secondEntity.name, nameNewTable, "1-N"));

                                    if (!existed.contains(firstEntity.name)) {
                                        resultDatabase.add(new RelationalSchema(firstEntity.name,
                                                firstEntity.attributes, firstEntity.primaryKey, ""));
                                        existed.add(firstEntity.name);
                                    }

                                    if (!existed.contains(secondEntity.name)) {
                                        resultDatabase.add(new RelationalSchema(secondEntity.name,
                                                secondEntity.attributes, secondEntity.primaryKey, ""));
                                        existed.add(secondEntity.name);
                                    }
                                }
                            }
                        }

                        // Quan hệ kế thừa
                        else if (relationship.type.equals("Inheritance")) {
                            // Khoá chính của quan hệ cha trở thành khoá chính của quan hệ con
                            String primaryKey = firstEntity.primaryKey;
                            for (ERD secondEntity : database) {
                                if (relationship.secondEntity.equals(secondEntity.name)) {
                                    if (!existed.contains(firstEntity.name)) {
                                        resultDatabase.add(new RelationalSchema(firstEntity.name,
                                                firstEntity.attributes, firstEntity.primaryKey, ""));
                                        existed.add(firstEntity.name);
                                    }
                                    if (!existed.contains(secondEntity.name)) {
                                        resultDatabase.add(new RelationalSchema(secondEntity.name,
                                                secondEntity.attributes + ',' + primaryKey,
                                                primaryKey, primaryKey));
                                        existed.add(secondEntity.name);
                                    }
                                }
                            }
                        }

                        // Quan hệ thực thể mạnh - thực thể yếu
                        else if (relationship.type.equals("Strong-Weak")) {
                            String foreignKey = firstEntity.primaryKey;
                            for (ERD secondEntity : database) {
                                if (!existed.contains(firstEntity.name)) {
                                    resultDatabase.add(new RelationalSchema(firstEntity.name,
                                            firstEntity.attributes, firstEntity.primaryKey, ""));
                                    existed.add(firstEntity.name);
                                }
                                if (!existed.contains(secondEntity.name)) {
                                    resultDatabase.add(new RelationalSchema(secondEntity.name,
                                            secondEntity.attributes + ',' + foreignKey,
                                            secondEntity.primaryKey + ',' +foreignKey,
                                            foreignKey));
                                }
                            }
                        }
                    }
                }
            }

            try (BufferedWriter myOutput = new BufferedWriter(new FileWriter(outputPath))) {
                for (RelationalSchema schema : resultDatabase) {
                    myOutput.write(schema.toString());
                    myOutput.newLine();
                }

                for (Relationship relationship : relationships) {
                    myOutput.write(relationship.toString());
                    myOutput.newLine();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        ERDToRelationalSchema("input.txt", "output.txt");
    }
}