import java.io.File;
import java.io.FileNotFoundException;
import java.util.*;

public class Main {
    static int width;

    public static void main(String[] args) throws FileNotFoundException {
        String f1 = "Primeri//primer5_zacetna.txt";
        String f2 = "Primeri//primer5_koncna.txt";

        String startPos = Main.readInput(f1);
        String endPos = Main.readInput(f2);
        System.out.println("Start matrix");
        Main.printMatrix(startPos, width);
        System.out.println("End matrix");
        Main.printMatrix(endPos, width);

        int maxDepth = 30;
        boolean draw = false;

        DFS.runDFS(f1, f2, maxDepth);
        BFS.runBFS(f1, f2, draw);
        IDDFS.runIDDFS(f1, f2, draw);
        GBFS.runGBFS(f1, f2);
        Astar.runAstar(f1, f2, draw);
        IDAstar.runIDAstar(f1, f2, true);

    }
    static String readInput(String filename) throws FileNotFoundException {
        File file = new File(filename);
        Scanner sc1 = new Scanner(file);
        ArrayList<String[]> tab = new ArrayList<>();
        while(sc1.hasNextLine()){
            tab.add(sc1.nextLine().split(","));
        }
        Main.width = tab.get(0).length;
        StringBuilder out = new StringBuilder();
        for (int i = 0; i < tab.size(); i++) {
            for (int j = 0; j < tab.get(0).length; j++) {
                String str = tab.get(i)[j];
                str = String.valueOf(str.charAt(1));
                out.append(str);
            }
        }
        return out.toString();
    }
    static int getWidth() {
        return Main.width;
    }
    static char[][] stringToMatrix(String str, int width) {
        char[][] newtab = new char[str.length() / width][width];
        for (int i = 0; i < newtab.length; i++) {
            for (int j = 0; j < newtab[0].length; j++) {
                newtab[i][j] = str.charAt(i + j);
            }
        }
        return newtab;
    }
    static String matrixToString(char[][] matrix) {
        StringBuilder out = new StringBuilder();
        for (int i = 0; i < matrix.length; i++) {
            for (int j = 0; j < matrix[0].length; j++) {
                out.append(matrix[i][j]);
            }
        }
        return out.toString();
    }
    static void printMatrix(String str, int width) {
        StringBuilder out = new StringBuilder();
        for (int i = 0; i < str.length(); i++) {
            if(i > 0 && i % width == 0)
                out.append("|\n");
            char chr = str.charAt(i);
            if(chr == ' ')
                chr = '_';
            out.append("|" + chr);
        }
        out.append("|\n");
        System.out.println(out);
    }
}

// vozlisce
class State {
    int width;
    // generated child nodes (moves)
    boolean generatedChilds = false;
    boolean marked = false;
    int heuristicRate;
    int distance;

    // prevState leading into this state
    State prevState;
    // Move (p, r) leading from prevState to currState
    Move move;

    // current state represented in string (Matrix to String)
    String currPos;
    ArrayList<State> possibleStates;

    State(String str, Move move, int distance) {
        this.distance = distance;
        this.move = move;
        this.currPos = str;
        this.possibleStates = new ArrayList<>();
    }

    void generateAllPossibleStates(HashSet<String> arr, int width) {
        // vsi mozni premiki
        // p == i
        // r == j
        // poglej ali je premik valid, ali premik NI previousPremik
        // if valid ... make new State
        for (int i = 0; i < width; i++) {
            for (int j = 0; j < width; j++) {
                if (this.move == null || !(i == this.move.r && j == this.move.p)) {
                    if(i != j && this.currPos.charAt(j) == ' ' && this.currPos.charAt(this.currPos.length() - (width-i)) != ' ') {
                        int[] ele_pos = move(i, j, width);
                        if (ele_pos != null) {
                            State newState = new State(switchElement(this.currPos, ele_pos), new Move(i, j), this.distance+1);
                            newState.prevState = this;
                            if (arr.add(newState.currPos))
                                this.possibleStates.add(newState);
                        }
                    }
                }
            }
        }
    }
    void generateHeuristic1(String end) {
        int rate = 0;
        for (int i = 0; i < end.length(); i++) {
            char chr = end.charAt(i);
            if(chr != ' ' && this.currPos.charAt(i) != chr)
                rate++;
        }
        this.heuristicRate = rate;
    }
    void generateHeuristic(String end) {
        int width = Main.width;
        int rate = 0;
        int[] tab_width = new int[width];
        for (int i = end.length()-1; i >=0 ; i--) {
            char chr = currPos.charAt(i);
            if(chr != ' ') {
                if(end.charAt(i) != chr) {
                    tab_width[i % width]++;
                    rate++;
                }
                else if (tab_width[i % width] > 0){
                    rate+=2;
                }
            }
        }
        this.heuristicRate = rate;
    }

    int[] move(int p, int r, int width) {
        int strlength = this.currPos.length();
        boolean move = false;
        char ele = ' ';
        int indexOld = 0;

        // move from
        for (int i = p; i < strlength; i+=width) {
            ele = this.currPos.charAt(i);
            if(ele != ' ') {
                indexOld = i;
                break;
            }
        }
        // move to
        if(ele != ' ') {
            for (int i = strlength - (width-r); i >= 0; i-=width) {
                if(this.currPos.charAt(i) == ' ') {
                    return new int[]{indexOld, i};
                }
            }
        }
        return null;
    }

    String switchElement(String currPos, int[] tab) {
        StringBuilder out = new StringBuilder(currPos);
        int p = tab[0];
        int r = tab[1];
        char ele = currPos.charAt(p);
        out.setCharAt(p, currPos.charAt(r));
        out.setCharAt(r, ele);
        return out.toString();
    }
    void printStates() {
        for(State state: this.possibleStates) {
            System.out.println(state);
        }
    }

    @Override
    public String toString() {
        StringBuilder out = new StringBuilder();
        for (int i = 0; i < this.currPos.length(); i++) {
            if(i > 0 && i % Main.width == 0)
                out.append("|\n");
            char chr = this.currPos.charAt(i);
            if(chr == ' ')
                chr = '_';
            out.append("|" + chr);
        }
        out.append('|');
        return out.toString();
    }
}

class Move {
    int r;
    int p;

    Move(int p, int r) {
        this.r = r;
        this.p = p;
    }

    @Override
    public String toString() {
        return "premik(" + this.p + ", " + this.r + ")";
    }
}
