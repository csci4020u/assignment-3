import static java.lang.System.out;

class Action {
    public static void print(double value) {
        out.printf("%.2f\n", value);
    }
    public static void print(String value) {
        out.print(value);
    }
    public static void println() {
        out.println();
    }
    public static String toString(String value) {
        return value.substring(1, value.length()-1);
    }
    public static String toString(double value) {
        return new Double(value).toString();
    }
    public static String toString(double value, String d) {
        return String.format("%." + d + "f", value);
    }
}
