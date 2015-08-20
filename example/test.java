public class HelloWorld {

    public String phrase = "Hello, World!";
    public List<String> list = new ArrayList<String>();
    private static int a;
    protected static final int b = 1;
    private static volatile List<String> testVariable;
    private String dontGenThisOne;

    public void run() {
        System.out.println(phrase);
    }

    public String getDontGenThisOne() {
        return this.dontGenThisOne;
    }

    public void setDontGenThisOne(String dontGenThisOne) {
        this.dontGenThisOne = dontGenThisOne;
    }

}
