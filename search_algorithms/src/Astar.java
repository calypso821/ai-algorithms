import java.io.FileNotFoundException;
import java.util.*;

public class Astar {
    static int width;
    static int max_ele_RAM = 0;
    static int num_traversed  = 0;

    public static void search(String startPos, String endPos, boolean draw)
    {


        PriorityQueue<State> pq = new PriorityQueue<>(new Comparator<State>() {
            public int compare(State o1, State o2) {
                return (o1.heuristicRate + o1.distance) - (o2.heuristicRate + o2.distance);
            }
        });

        long start = System.currentTimeMillis();
        HashSet<String> traversed1 = new HashSet<>();
        State root = new State(startPos, null, 0);
        root.generateHeuristic(endPos);

        int path_length = 1;

        pq.add(root);

        while(!pq.isEmpty())
        {
            num_traversed++;
            State currState = pq.remove();

            if (currState.currPos.equals(endPos)) {
                State result = currState;
                System.out.println("\nResitev Astar v stanju\n");
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

                System.out.println("\n------- A* -------");
                System.out.println("Dolzina poti: " + path_length);
                System.out.println("Stevilo vseh pregledanih stanj: " + num_traversed);
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
            if(pq.size() > max_ele_RAM)
                max_ele_RAM = pq.size();
        }
    }
    public static void runAstar(String f1, String f2, boolean izris) throws FileNotFoundException {
        System.out.println("Starting A* ...");
        String startPos = Main.readInput(f1);
        String endPos = Main.readInput(f2);
        Astar.width = Main.getWidth();

        Astar.search(startPos, endPos, izris);
    }

    public static void main(String[] args) throws FileNotFoundException {
        String f1 = "Primeri//primer4_zacetna.txt";
        String f2 = "Primeri//primer4_koncna.txt";

        runAstar(f1, f2, true);
    }
}