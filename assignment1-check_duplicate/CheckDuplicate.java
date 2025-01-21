import java.util.ArrayList;
import java.util.List;

public class CheckDuplicate {
    public static void main(String[] args) {
        // Input list
        List<Integer> listA = List.of(1, 2, 3, 5, 6, 8, 9);
        List<Integer> listB = List.of(3, 2, 1, 5, 6, 0);

        // Find and sort
        List<Integer> listNew = new ArrayList<>();
        // Check for duplicates
        for (Integer itemA : listA) {
            for (Integer itemB : listB) {
                // Check match and not in new list
                if (itemA.equals(itemB) && !listNew.contains(itemA)) {
                    // Add to new list
                    listNew.add(itemA);
                }
            }
        }

        System.out.println("Duplicate items: " + listNew);
    }
}