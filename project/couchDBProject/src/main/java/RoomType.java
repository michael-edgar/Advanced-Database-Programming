import com.google.gson.JsonObject;
import com.google.gson.JsonParseException;
import com.google.gson.JsonParser;

public enum RoomType {
    //Following are examples used for setup
    SINGLE(1, new String[]{"Single"}, 80.00f),
    TWIN(2, new String[]{"Single", "Single"}, 100.00f),
    DOUBLE(2, new String[]{"Double"}, 100.00f),
    KING(2, new String[]{"King"}, 140.00f),
    SUITE(2, new String[]{"Queen"}, 150.00f),
    TRIPLE(3, new String[]{"Single", "Single", "Single"}, 120.00f),
    FAMILY(4, new String[]{"Double","Single", "Single"}, 130.00f),
    DELETE_ME(0, new String[]{"delete me"}, 1.00f);

    private int roomTypeCapacity;
    private String[] roomTypeBeds;
    private float roomTypePrice;

    RoomType(int roomCapacity, String[] roomBeds, float roomTypePrice) {
        setRoomTypeCapacity(roomCapacity);
        setRoomTypeBeds(roomBeds);
        setRoomTypePrice(roomTypePrice);
    }

    public static RoomType getRoomFromJSON(JsonObject jsonObject) {
        for (RoomType roomType: RoomType.values()) {
            if(roomType.getRoomTypeCapacity() == jsonObject.get("roomCapacity").getAsInt() && roomType.getRoomTypePrice() == jsonObject.get("roomPrice").getAsFloat())
                return roomType;
        }
        return SINGLE;
    }

    @Override
    public String toString() {
        StringBuilder roomType = new StringBuilder("{\"roomTypeName\": \"" + this.name() +"\", \"roomTypeCapacity\": \"" + getRoomTypeCapacity() + "\", \"roomTypeBeds\": [\"");
        String[] beds = getRoomTypeBeds();
        for(int i = 0; i < beds.length; i++) {
            roomType.append(beds[i]);
            if(i != beds.length - 1) roomType.append("\", \"");
            else roomType.append("\"], ");
        }
        roomType.append("\"roomTypePrice\": \"").append(getRoomTypePrice()).append("\"}");
        return roomType.toString();
    }

    public JsonObject toJson() {
        try {
            JsonParser parser = new JsonParser();
            return  (JsonObject)parser.parse(this.toString());
        }
        catch (JsonParseException err) {
            throw new JsonParseException("Unable to parse room type");
        }
    }

    public int getRoomTypeCapacity() {
        return roomTypeCapacity;
    }

    public String[] getRoomTypeBeds() {
        return roomTypeBeds;
    }

    public float getRoomTypePrice() {
        return roomTypePrice;
    }

    public void setRoomTypeCapacity(int roomTypeCapacity) {
        this.roomTypeCapacity = roomTypeCapacity;
    }

    public void setRoomTypeBeds(String[] roomTypeBeds) {
        this.roomTypeBeds = roomTypeBeds;
    }

    public void setRoomTypePrice(float roomTypePrice) {
        this.roomTypePrice = roomTypePrice;
    }
}
