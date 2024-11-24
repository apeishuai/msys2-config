class FruitFactory:
    @staticmethod
    def create_fruit(fruit_type):
        if fruit_type == "banana":
            return Banana()
        elif fruit_type == "apple":
            return Apple()
        else:
            raise ValueError("Unknown fruit type")

class Banana:
    def __str__(self):
        return "Banana"

class Apple:
    def __str__(self):
        return "Apple"
