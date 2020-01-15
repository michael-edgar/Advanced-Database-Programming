import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.List;

public class UpdateRoom {
    private static JFrame updateRoomFrame;
    private static List<Room> allRooms = Database.getAllRooms();
    private static JComboBox rooms;
    private static String roomTypeText = "";
    private static JTextField roomType = new JTextField(8);

    public static void updateRooms() {
        String[] roomNumbers = getAllRoomNumbersString();
        updateRoomFrame = new JFrame("Update Room");
        updateRoomFrame.setLayout(new FlowLayout());
        updateRoomFrame.setSize(500, 100);
        rooms = new JComboBox(roomNumbers);
        rooms.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                updateTextField();
            }
        });
        JLabel typeLabel = new JLabel("Room Type: ");
        JButton confirmChanges = new JButton("Update Room Type");
        confirmChanges.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                if(!roomTypeText.equals(roomType.getText())) {
                    allRooms = Database.getAllRooms();
                    Room updatedRoom = allRooms.get(rooms.getSelectedIndex());
                    updatedRoom.setRoomType(RoomType.valueOf(roomType.getText()));
                    Database.updateRoomInDB(updatedRoom);
                }
            }
        });
        updateRoomFrame.add(rooms);
        updateRoomFrame.add(typeLabel);
        updateRoomFrame.add(roomType);
        updateRoomFrame.add(confirmChanges);
        updateRoomFrame.setVisible(true);
    }

    private static String[] getAllRoomNumbersString() {
        int[] allRoomNumbers = getAllRoomNumbers();
        String[] roomNumbers = new String[allRoomNumbers.length];

        for(int i = 0; i < allRoomNumbers.length; i++) {
            roomNumbers[i] = "Room Number: " + allRoomNumbers[i];
        }
        return roomNumbers;
    }

    private static int[] getAllRoomNumbers() {
        allRooms = Database.getAllRooms();
        int[] roomNumbers = new int[allRooms.size()];
        for(int i = 0; i < allRooms.size(); i++) {
            roomNumbers[i] = allRooms.get(i).getRoomNumber();
        }
        return roomNumbers;
    }

    public static int getNextRoomNumber() {
        int[] roomNumbers = getAllRoomNumbers();
        int greatestRoomNumber = 0;
        for(int i : roomNumbers) {
            if(i > greatestRoomNumber)
                greatestRoomNumber = i;
        }
        return greatestRoomNumber+1;
    }

    private static void updateTextField() {
        allRooms = Database.getAllRooms();
        Room currentRoom = allRooms.get(rooms.getSelectedIndex());
        roomTypeText = currentRoom.getRoomType().name();
        roomType.setText(roomTypeText);
        updateRoomFrame.repaint();
    }
}
