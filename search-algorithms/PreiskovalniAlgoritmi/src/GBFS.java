import java.io.FileNotFoundException;
import java.util.*;

public class GBFS {
    static int width;
    static int max_ele_RAM = 0;

    public static void search(String startPos, String endPos)
    {


        PriorityQueue<State> pq = new PriorityQueue<>(new Comparator<State>() {
            public int compare(State o1, State o2) {
                return o1.heuristicRate - o2.heuristicRate;
            }
        });
        
        long start = System.currentTimeMillis();
        HashSet<String> traversed1 = new HashSet<>();
        State root = new State(startPos, null, 0);
        root.generateHeuristic(endPos);

        int depth = 0;
        int path_length = 1;

        pq.add(root);

        while(!pq.isEmpty())
        {
            if(pq.size() > max_ele_RAM)
                max_ele_RAM = pq.size();
            State currState = pq.remove();

            if (currState.currPos.equals(endPos)) {
                State result = currState;
                System.out.println("\nResitev GBFS (Greedy best-first search) v stanju\n");
                Main.printMatrix(result.currPos, width);
                System.out.print("Pot: " + result.move);

                // print path
                while (true) {
                    result = result.prevState;
                    if (result != null && result.move != null) {
                        //System.out.println(result);
                        path_length++;
                        System.out.print(" <-- " + result.move);
                    }
                    else
                        break;
                }
                long finish = System.currentTimeMillis();
                long timeElapsed = finish - start;

                System.out.println("\n------- GBFS -------");
                System.out.println("Dolzina poti: " + path_length);
                System.out.println("Stevilo vseh pregledanih stanj: " + (traversed1.size() - pq.size()));
                System.out.println("Max ele v pomnilniku: " + max_ele_RAM);
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
                nextState.generateHeuristic(endPos);
                pq.add(nextState);
                traversed1.add(nextState.currPos);
            }
        }
    }

    public static void runGBFS(String f1, String f2) throws FileNotFoundException {
        System.out.println("Starting GBFS (Greedy best-first search) ...");
        String startPos = Main.readInput(f1);
        String endPos = Main.readInput(f2);
        GBFS.width = Main.getWidth();

        GBFS.search(startPos, endPos);
    }

    public static void main(String[] args) throws FileNotFoundException {
        String f1 = "Primeri//primer4_zacetna.txt";
        String f2 = "Primeri//primer4_koncna.txt";
        runGBFS(f1, f2);
    }
}