from fac import FruitFactory

def main():
    banana1 = FruitFactory.create_fruit("banana")
    banana2 = FruitFactory.create_fruit("banana")
    apple1 = FruitFactory.create_fruit("apple")
    apple2 = FruitFactory.create_fruit("apple")

    print(banana1)
    print(banana2)
    print(apple1)
    print(apple2)

if __name__ == "__main__":
    main()
