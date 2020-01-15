import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.List;

public class DeleteRoom {
    private static JFrame deleteFrame;
    private static List<Room> allRooms = Database.getAllRooms();
    private static JComboBox rooms = new JComboBox();
    private static JButton deleteRoom = new JButton("Confirm Delete");

    public static void deleteRoomFrame() {
        deleteFrame = new JFrame("Delete Room");
        deleteFrame.setLayout(new FlowLayout());
        deleteFrame.setSize(500, 150);
        allRooms = Database.getAllRooms();
        for(Room room: allRooms) {
            rooms.addItem(room.getRoomNumber());
        }
        deleteRoom.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                deleteRoomFromDB();
            }
        });
        deleteFrame.add(rooms);
        deleteFrame.add(deleteRoom);
        deleteFrame.setVisible(true);
    }

    private static void deleteRoomFromDB() {
        allRooms = Database.getAllRooms();
        int currentIndex = rooms.getSelectedIndex();
        Database.deleteRoomInDB(allRooms.get(currentIndex));
        rooms.setSelectedIndex(0);
        rooms.removeItemAt(currentIndex);
    }
}

