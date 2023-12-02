import itertools

# Hàm chuyển đổi một tập hợp thành một chuỗi
def convert_set_to_string(attribute_set):
    '''Lặp qua các phần tử trong tập hợp và ghép chúng lại thành một chuỗi'''
    return "".join(attribute for attribute in attribute_set)

#  Hàm chuyển đổi một chuỗi thành một tập hợp
def convert_string_to_set(string):
    '''Tách chuỗi theo dấu phẩy và tạo một tập hợp từ các phần tử tách được'''
    attributes = string.split(",")
    return set(attributes)

# Lớp phụ thuộc hàm
class FunctionalDependency:
    def __init__(self, LeftAttribute, RightAttributes):
        self.LeftAttribute = LeftAttribute
        self.RightAttributes = RightAttributes

    def __str__(self):
        return "{} -> {}".format(convert_set_to_string(self.LeftAttribute), convert_set_to_string(self.RightAttributes))

# Lớp chứa các phụ thuộc hàm
class FDSet(set):
    # Hàm cập nhật phụ thuộc hàm ở bên trái 
    def UL(self):
        resLeftAttributet = set()
        for fd in self:
            resLeftAttributet.update(fd.LeftAttribute)
        return resLeftAttributet

    # Hàm cập nhật phụ thuộc hàm ở bên phải
    def UR(self):
        resLeftAttributet = set()
        for fd in self:
            resLeftAttributet.update(fd.RightAttributes)
        return resLeftAttributet

    # Hàm tính bao đóng
    def FindClose(self, attributes):
        X = set(attributes)
        still_change = True
        while still_change:
            still_change = False
            '''Duyệt qua tất cả phụ thuộc hàm'''
            for fd in self:
                '''Nếu các thuộc tính bên trái của phụ thuộc hàm là tập con của tập X
                và (các thuộc tính bên phải chưa có trong X) thì cập nhật các thuộc tính bên phải đó vào X'''
                if fd.LeftAttribute.issubset(X) and not fd.RightAttributes.issubset(X):
                    still_change = True
                    X.update(fd.RightAttributes)
        return X

    # Hàm tìm khóa
    def Findkeys(self, attributes):
        '''N = U - UR'''
        N = attributes.difference(self.UR())
        '''Nếu N+ = U thì N là khóa duy nhất'''
        if self.FindClose(N) == attributes:
            return [convert_set_to_string(N)]
        '''D = UR - UL'''
        D = self.UR().difference(
            self.UL())
        '''L = U - N union D'''
        L = attributes.difference(N.union(D))
        
        power_set_L = []
        '''Duyệt Li gồm 1 thuộc tính'''
        for i in range(len(L)):
            for element in itertools.combinations(L, i + 1):
                power_set_L.append(element)
        
        resLeftAttributet = []
        Key = [] # Khởi tạo tập Key chứa các khóa
        
        for Li in power_set_L:
            is_key = False
            Li = set(Li)
            '''Duyệt Li qua các khóa trong tập Key nếu là tập con của khóa thì bỏ qua'''
            for element in Key:
                if element.issubset(Li):
                    is_key = True
            if is_key:
                continue
            '''X = N uinion Li'''
            X = N.union(Li)
            '''Nếu X+ = U thì '''
            if self.FindClose(X) == attributes:
                resLeftAttributet.append(convert_set_to_string(X))
                Key.append(Li)
        
        return resLeftAttributet

# Class to represent a Relation
class Relation:
    def __init__(self, name="", attributes=""):
        self.name = name
        self.attributes = attributes
        self.fd_set = FDSet()

# Function to count lines in a file
def count_lines_in_file(file_path):
    count = 0
    with open(file_path, "r") as my_file:
        lines = my_file.readlines()
        count = len(lines)
    return count

# Function to load data from a file into relations
def load_file(file_path):
    relations = []
    with open(file_path, "r") as my_input:
        lines = my_input.readlines()
        for line in lines:
            data = line.rstrip('\n').split(" ")
            relation = Relation(data[0], data[1])
            fd_set = data[2].split(";")
            for fd in fd_set:
                relation.fd_set.add(FunctionalDependency(
                    convert_string_to_set(fd.split("_")[0]),
                    convert_string_to_set(fd.split("_")[1])
                ))
            relations.append(relation)
    return relations

# Function to write data to a file
def write_to_file(file_path, relations, X):
    with open(file_path, "w") as my_output:
        for relation in relations:
            my_output.writelines(
                convert_set_to_string(relation.fd_set.FindClose(X)) +
                " " +
                ','.join(relation.fd_set.keys(convert_string_to_set(relation.attributes)))
            )
            my_output.write("\n")


# RunCode
X = input("Enter attribute set X: ").rstrip('\n')
relations = load_file("input.txt")
write_to_file("output.txt", relations, X)


