public class HelloWorld {

    public String phrase = "Hello, World!";
    public List<String> list = new ArrayList<String>();
    private static int a;
    protected static final int b = 1;
    private static volatile List<String> testVariable;

    public void run() {
        System.out.println(phrase);
    }
}
