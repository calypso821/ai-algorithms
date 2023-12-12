
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Stack;

public class DFS {
    static int width;
    static int max_ele_RAM = 0;
    static int num_traversed  = 0;

    public static void search(String startPos, String endPos, int maxDepth)
    {

        Stack<State> stack = new Stack<State>();
        long start = System.currentTimeMillis();
        HashSet<String> traversed1 = new HashSet<>();
        State root = new State(startPos, null, 0);

        int depth = 0;
        int path_length = 1;

 
        stack.push(root);
        

        while(!stack.isEmpty())
        {
            num_traversed++;
            State currState = stack.peek();

            if (currState.currPos.equals(endPos)) {
                State result = currState;
                System.out.println("Resitev DFS v stanju\n");
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
                System.out.println("\n------- DFS -------");
                System.out.println("Dolzina poti: " + path_length);
                System.out.println("Stevilo vseh pregledanih stanj: " + num_traversed);
                System.out.println("Max ele v pomnilniku (stack): " + max_ele_RAM);
                System.out.println("Porabljen cas: " + timeElapsed + " ms");
                System.out.println("---------------------------------------------------------" +
                        "-------------------------------------------");
                return;
            }
            if(depth < maxDepth && !currState.generatedChilds) {
                currState.generateAllPossibleStates(traversed1, width);
                // mark as traversed
                currState.generatedChilds = true;
            }

            // najdi neobiskanega naslednjika
            boolean found = false;
            for (State nextState : currState.possibleStates) {
                if(!nextState.marked) {
                    nextState.marked = true;
                    stack.push(nextState);
                    traversed1.add(nextState.currPos);
                    depth++;
                    found = true;

                    if(stack.size() > max_ele_RAM)
                        max_ele_RAM = stack.size();

                    break;
                }
            }

            if (!found)
            {
                stack.pop();
                depth--;
            }
        }
    }

    public static void runDFS(String f1, String f2, int maxDepth) throws FileNotFoundException {
        System.out.println("Starting DFS ...");
        String startPos = Main.readInput(f1);
        String endPos = Main.readInput(f2);
        DFS.width = Main.getWidth();

        DFS.search(startPos, endPos, maxDepth);
    }

    public static void main(String[] args) throws FileNotFoundException {
        String f1 = "Primeri//primer4_zacetna.txt";
        String f2 = "Primeri//primer4_koncna.txt";
        int maxDepth = 30;
        runDFS(f1, f2, maxDepth);
    }

}