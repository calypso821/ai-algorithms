import java.io.FileNotFoundException;
import java.util.*;

public class IDAstar {
    static int max_ele_RAM = 0;
    static int width;
    static int recursion_depth = 0;
    static boolean found;
    static int num_traversed  = 0;

    static PriorityQueue<State> pq = new PriorityQueue<>(new Comparator<State>() {
        public int compare(State o1, State o2) {
            return (o1.heuristicRate + o1.distance) - (o2.heuristicRate + o2.distance);
        }
    });

    static HashSet<String> traversed1 = new HashSet<>();
    static State result;

    public static void find(String startPos, String endPos, boolean draw) {



        long start = System.currentTimeMillis();

        State root = new State(startPos, null, 0);
        root.generateHeuristic(endPos);
        int bound = root.heuristicRate;

        // Start by doing DFS with a depth of 1, keep doubling depth until we reach the "bottom" of the tree or find the node we're searching for
        int path_length = 1;

        while (true) {
            int res = search(root, bound, endPos);
            pq.remove();
            if (found) {
                // We've found the goal node while doing DFS with this max depth
                System.out.println("\nResitev IDAstar v stanju\n");
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

                System.out.println("\n------- ID A* -------");
                System.out.println("Dolzina poti: " + path_length);
                System.out.println("Stevilo vseh pregledanih stanj: " + num_traversed);
                System.out.println("Max ele v pomnilniku: " + (max_ele_RAM + path_length));
                System.out.println("Porabljen cas: " + timeElapsed + " ms");
                System.out.println("---------------------------------------------------------" +
                        "-------------------------------------------");

                return;
            }

            // We haven't found the goal node, but there are still deeper nodes to search through
            bound  = res;
            System.out.println("Increasing bound to " + bound);
        }

        // Bottom reached is true.
        // We haven't found the node and there were no more nodes that still have children to explore at a higher depth.
    }

    public static int search(State currState, int bound, String endPos)
    {
        num_traversed++;
        pq.add(currState);

        if(pq.size() > max_ele_RAM)
            max_ele_RAM = pq.size();

        int currScore = currState.distance + currState.heuristicRate;

        if(currScore > bound)
            return currScore;


        if (currState.currPos.equals(endPos)) {
            found = true;
            result = currState;
            return currScore;
        }

        if(!currState.generatedChilds) {
            currState.generateAllPossibleStates(traversed1, width);
            // mark as traversed
            currState.generatedChilds = true;
        }
        int min = Integer.MAX_VALUE;
        for (State nextState : currState.possibleStates) {
            nextState.generateHeuristic(endPos);
            recursion_depth++;
            int res = search(nextState, bound, endPos);
            recursion_depth--;
            if(found)
                return res;
            if(res < min)
                min = res;
            pq.remove();
        }
        return min;
    }
    public static void runIDAstar(String f1, String f2, boolean izris) throws FileNotFoundException {
        System.out.println("Starting IDA* (Iterative Deepening A*) ...");
        String startPos = Main.readInput(f1);
        String endPos = Main.readInput(f2);
        IDAstar.width = Main.getWidth();

        IDAstar.find(startPos, endPos, izris);
    }

    public static void main(String[] args) throws FileNotFoundException {
        String f1 = "Primeri//primer4_zacetna.txt";
        String f2 = "Primeri//primer4_koncna.txt";
        runIDAstar(f1, f2, false);
    }
}