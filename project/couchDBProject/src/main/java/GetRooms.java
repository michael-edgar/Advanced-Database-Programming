import javax.swing.*;
import java.awt.*;
import java.util.List;

public class GetRooms {
    public static void roomView() {
        List<Room> allRooms = Database.getAllRooms();
        String[] rooms = new String[allRooms.size()+1];
        for (int i = 0; i < allRooms.size(); i++)
            rooms[i] = allRooms.get(i).toString();
        rooms[allRooms.size()] = "Number of rooms: " + Database.getNumberOfRooms();
        JFrame roomsFrame = new JFrame("Rooms");
        roomsFrame.setLayout(new FlowLayout());
        roomsFrame.setSize(900, frameLengthModifier());
        JList roomList = new JList(rooms);
        roomsFrame.add(roomList);
        roomsFrame.setVisible(true);
    }

    private static int frameLengthModifier() {
        return 200 + (10 * Database.getNumberOfRooms());
    }
}
