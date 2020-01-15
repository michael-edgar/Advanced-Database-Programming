import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.List;

public class CreateRoom {
    private static JSpinner roomNumber = new JSpinner();
    private static JComboBox roomType = new JComboBox();
    private static JButton createRoomButton = new JButton("Create Room");
    private static List<RoomType> allRoomTypes = Database.getAllRoomTypes();
    private static SpinnerModel range;

    public static void createRoomFrame() {
        range = new SpinnerNumberModel(UpdateRoom.getNextRoomNumber(), UpdateRoom.getNextRoomNumber(), 199, 1);
        roomNumber.setModel(range);
        roomNumber.setEditor(new JSpinner.DefaultEditor(roomNumber));
        JFrame createRoomFrame = new JFrame("Create Room");
        createRoomFrame.setLayout(new FlowLayout());
        createRoomFrame.setSize(500, 100);
        JLabel roomNo = new JLabel("Room Number: ");
        JLabel roomTypeLabel = new JLabel("Room Type");
        allRoomTypes = Database.getAllRoomTypes();
        for(RoomType type: allRoomTypes) {
            roomType.addItem(type.name());
        }
        createRoomButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                createTheRoom();
            }
        });
        createRoomFrame.add(roomNo);
        createRoomFrame.add(roomNumber);
        createRoomFrame.add(roomTypeLabel);
        createRoomFrame.add(roomType);
        createRoomFrame.add(createRoomButton);
        createRoomFrame.setVisible(true);
    }

    private static void createTheRoom() {
        allRoomTypes = Database.getAllRoomTypes();
        Database.createRoomInDB(new Room(Integer.parseInt(roomNumber.getValue().toString()), allRoomTypes.get(roomType.getSelectedIndex())));
        range.setValue(range.getNextValue());
    }
}
