import java.io.FileNotFoundException;
import java.util.*;


public class IDDFS {
    private static boolean bottomReached = false; // Variable to keep track if we have reached the bottom of the tree
    static int width;
    static int num_traversed  = 0;

    public static void find(String startMat, String endMat, boolean draw) {

        long start = System.currentTimeMillis();
        HashSet<String> traversed1 = new HashSet<>();
        State root = new State(startMat, null, 0);

        // Start by doing DFS with a depth of 1, keep doubling depth until we reach the "bottom" of the tree or find the node we're searching for
        int depth = 0;
        int path_length = 1;

        while (!bottomReached) {
            bottomReached = true; // One of the "end nodes" of the search with this depth has to still have children and set this to false again
            State result = IDDFS(root, endMat, 0, depth, traversed1);
            if (result != null) {
                // We've found the goal node while doing DFS with this max depth
                System.out.println("\nResitev IDDFS v stanju\n");
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
                    Main.printMatrix(startMat, width);
                }
                long finish = System.currentTimeMillis();
                long timeElapsed = finish - start;

                System.out.println("\n------- IDDFS -------");
                System.out.println("Dolzina poti: " + path_length);
                System.out.println("Stevilo vseh pregledanih stanj: " + num_traversed);
                System.out.println("Max ele v pomnilniku (rekurzija): " + path_length);
                System.out.println("Porabljen cas: " + timeElapsed + " ms");
                System.out.println("---------------------------------------------------------" +
                        "-------------------------------------------");
                return;
            }

            // We haven't found the goal node, but there are still deeper nodes to search through
            depth++;
            System.out.println("Increasing depth to " + depth);
        }

        // Bottom reached is true.
        // We haven't found the node and there were no more nodes that still have children to explore at a higher depth.
    }

    private static State IDDFS(State currState, String endPos, int currentDepth, int maxDepth, HashSet<String> traversed1) {
        //System.out.println("Visiting Node " + currState);
        traversed1.add(currState.currPos);
        num_traversed++;


        if (currState.currPos.equals(endPos)) {
            return currState;
        }

        if (currentDepth == maxDepth) {
            //System.out.println("Current maximum depth reached, returning...");
            // We have reached the end for this depth...
            //if (node.children.length > 0) {
                //...but we have not yet reached the bottom of the tree
            bottomReached = false;
           // }
            return null;
        }
        if(!currState.generatedChilds) {
            currState.generateAllPossibleStates(traversed1, width);
            // mark as traversed
            currState.generatedChilds = true;
        }

        // Recurse with all children
        for (State nextState : currState.possibleStates) {
            State res = IDDFS(nextState, endPos, currentDepth + 1, maxDepth, traversed1);
            if (res != null) {
                // We've found the goal node while going down that child
                return res;
            }
        }
        // We've gone through all children and not found the goal node
        return null;
    }
    public static void runIDDFS(String f1, String f2, boolean izris) throws FileNotFoundException {
        System.out.println("Starting IDDFS (Iterative Deepening DFS) ...");
        String startPos = Main.readInput(f1);
        String endPos = Main.readInput(f2);
        IDDFS.width = Main.getWidth();

        IDDFS.find(startPos, endPos, izris);
    }

    public static void main(String[] args) throws FileNotFoundException {
        String f1 = "Primeri//primer4_zacetna.txt";
        String f2 = "Primeri//primer4_koncna.txt";
        runIDDFS(f1, f2, true);
    }
}