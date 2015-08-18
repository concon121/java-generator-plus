public class HelloWorld {

    public String phrase = "Hello, World!";

    private volatile static final List<String> testVariable;

    public void run() {
        System.out.println(phrase);
    }

}
