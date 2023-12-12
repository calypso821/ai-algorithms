import java.io.FileNotFoundException;
import java.util.*;

public class BFS {
    static int width;
    static int max_ele_RAM = 0;

    public static void search(String startPos, String endPos, boolean draw)
    {

        long start = System.currentTimeMillis();
        HashSet<String> traversed1 = new HashSet<>();
        State root = new State(startPos, null, 0);

        Queue<State> queue = new LinkedList<State>();

        int path_length = 1;

        queue.add(root);

        while(!queue.isEmpty())
        {
            State currState = queue.remove();

            if (currState.currPos.equals(endPos)) {
                State result = currState;
                System.out.println("Resitev BFS v stanju\n");
                Main.printMatrix(result.currPos, width);
                System.out.print("Pot: " + result.move);

                // print path
                while (true) {
                    result = result.prevState;
                    if (result != null && result.move != null) {
                        //System.out.println(result);
                        path_length++;
                        if(draw) {
                            System.out.println();
                            System.out.println(result);
                            System.out.println();
                        }
                        System.out.print(" <-- " + result.move);
                    }
                    else
                        break;
                }
                if(draw) {
                    System.out.println();
                    Main.printMatrix(startPos, width);
                }
                long finish = System.currentTimeMillis();
                long timeElapsed = finish - start;
                System.out.println("\n------- BFS -------");
                System.out.println("Dolzina poti: " + path_length);
                System.out.println("Stevilo vseh pregledanih stanj: " + (traversed1.size() - queue.size()));
                System.out.println("Max ele v pomnilniku (queue): " + max_ele_RAM);
                System.out.println("Porabljen cas: " + timeElapsed + " ms");
                System.out.println("---------------------------------------------------------" +
                        "-------------------------------------------");

                return;
            }
            if(!currState.generatedChilds) {
                currState.generateAllPossibleStates(traversed1, width);
                // mark as traversed
                currState.generatedChilds = true;
            }
            for (State nextState : currState.possibleStates) {
                if(!nextState.marked) {
                    nextState.marked = true;
                    queue.add(nextState);
                    traversed1.add(nextState.currPos);

                    if(queue.size() > max_ele_RAM)
                        max_ele_RAM = queue.size();
                }
            }
        }
    }

    public static void runBFS(String f1, String f2, boolean izris) throws FileNotFoundException {
        System.out.println("Starting BFS ...");
        String startPos = Main.readInput(f1);
        String endPos = Main.readInput(f2);
        BFS.width = Main.getWidth();

        BFS.search(startPos, endPos, izris);
    }

    public static void main(String[] args) throws FileNotFoundException {
        String f1 = "Primeri//primer4_zacetna.txt";
        String f2 = "Primeri//primer4_koncna.txt";
        runBFS(f1, f2, false);
    }
}