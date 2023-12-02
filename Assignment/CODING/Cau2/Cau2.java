import java.util.*;
import java.io.*;
import java.util.stream.Collectors;

class FunctionalDependency {
    Set<String> lhs;
    Set<String> rhs;

    public FunctionalDependency(Set<String> lhs, Set<String> rhs) {
        this.lhs = lhs;
        this.rhs = rhs;
    }

    @Override
    public String toString() {
        return lhs.stream()
                .sorted()
                .collect(Collectors.joining()) + " -> "
                + rhs.stream()
                        .sorted()
                        .collect(Collectors.joining());
    }
}

class FDSet extends HashSet<FunctionalDependency> {
    public Set<String> setOfAttributesInLeftHandSide() {
        Set<String> result = new HashSet<>();
        this.forEach(fd -> result.addAll(fd.lhs));
        return result;
    }

    public Set<String> setOfAttributesInRightHandSide() {
        Set<String> result = new HashSet<>(this.setOfAttributesInLeftHandSide());
        result.removeAll(this.setOfAttributesInLeftHandSide());
        return result;
    }

    public Set<String> closureOfAttributeSet(Set<String> attributes) {
        Set<String> result = new HashSet<>(attributes);
        boolean stillChange = true;
        while (stillChange) {
            stillChange = false;
            for (FunctionalDependency fd : this) {
                if (fd.lhs.stream().allMatch(result::contains) && !fd.rhs.stream().allMatch(result::contains)) {
                    stillChange = true;
                    result.addAll(fd.rhs);
                }
            }
        }
        return result;
    }

    public List<String> keys(Set<String> attributes) {
        Set<String> N = new HashSet<>(attributes);
        N.removeAll(setOfAttributesInRightHandSide());
        if (convertSetToString(closureOfAttributeSet(N)).equals(convertSetToString(attributes))) {
            return new ArrayList<>(N);
        }
        Set<String> D = new HashSet<>(setOfAttributesInRightHandSide());
        D.removeAll(setOfAttributesInLeftHandSide());
        Set<String> L = new HashSet<>(attributes);
        L.removeAll(N);
        L.removeAll(D);

        // Xây dựng tập hợp con của L
        List<Set<String>> powerSet = new ArrayList<>();
        powerSet.add(new HashSet<>()); // Thêm tập hợp rỗng làm bước ban đầu

        for (String attr : L) {
            List<Set<String>> newSets = new ArrayList<>();
            for (Set<String> subset : powerSet) {
                Set<String> newSubset = new HashSet<>(subset);
                newSubset.add(attr);
                newSets.add(newSubset);
            }
            powerSet.addAll(newSets);
        }

        List<String> result = new ArrayList<>();
        for (Set<String> Li : powerSet) {
            Set<String> X = new HashSet<>(N);
            X.addAll(Li);
            Set<String> closureX = closureOfAttributeSet(X);
            if (sortString(convertSetToString(closureX)).equals(sortString(convertSetToString(attributes)))) {
                result.add(convertSetToString(X));
            }
        }
        return result;
    }

    // Để tạo chuỗi từ một tập hợp
    public static String convertSetToString(Set<String> set) {
        return set.stream()
                .sorted()
                .collect(Collectors.joining());
    }

    // Để sắp xếp chuỗi
    public static String sortString(String str) {
        return str.chars()
                .sorted()
                .collect(StringBuilder::new, StringBuilder::appendCodePoint, StringBuilder::append)
                .toString();
    }

    public static int countLinesInFile(String filePath) throws IOException {
        int count = 0;
        try (BufferedReader myFile = new BufferedReader(new FileReader(filePath))) {
            while (myFile.readLine() != null) {
                count++;
            }
        }
        return count;
    }
}

class Relation {
    String name;
    String attributes;
    FDSet fdSet;
}

class Main {
    public static List<Relation> loadFile(String filePath) throws IOException {
        List<Relation> relations = new ArrayList<>();
        try (BufferedReader myInput = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = myInput.readLine()) != null) {
                String[] data = line.split(" ");
                Relation relation = new Relation();
                relation.name = data[0];
                relation.attributes = data[1];
                relation.fdSet = new FDSet();
                String[] fdSet = data[2].split(";");
                for (String fd : fdSet) {
                    String[] fdData = fd.split("_");
                    relation.fdSet.add(new FunctionalDependency(
                            Arrays.stream(fdData[0].split(",")).collect(Collectors.toSet()),
                            Arrays.stream(fdData[1].split(",")).collect(Collectors.toSet())));
                }
                relations.add(relation);
            }
        }
        return relations;
    }

    public static void writeToFile(String filePath, List<Relation> relations, String X) throws IOException {
        try (BufferedWriter myOutput = new BufferedWriter(new FileWriter(filePath))) {
            for (Relation relation : relations) {
                myOutput.write(convertSetToString(
                        relation.fdSet.closureOfAttributeSet(new HashSet<>(Arrays.asList(X.split(","))))) + " "
                        + String.join(",",
                                relation.fdSet.keys(new HashSet<>(Arrays.asList(relation.attributes.split(","))))));
                myOutput.newLine();
            }
        }
    }

    public static void main(String[] args) throws IOException {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter attribute set X: ");
        String X = scanner.nextLine();
        List<Relation> relations = loadFile("input.txt");
        writeToFile("output.txt", relations, X);
        scanner.close();
    }

    public static String convertSetToString(Set<String> set) {
        return set.stream()
                .sorted()
                .collect(Collectors.joining());
    }
}
