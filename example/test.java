public class HelloWorld {

    public String phrase = "Hello, World!";

    private static int a;
    private static final int b = 1;

    private volatile static final List<String> testVariable;

    public void run() {
        System.out.println(phrase);
    }

}
