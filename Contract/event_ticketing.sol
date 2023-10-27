pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

contract EventTicketToken is Initializable, ERC20Upgradeable, OwnableUpgradeable, UUPSUpgradeable {
    constructor() {
        initialize();
        _disableInitializers();
    }

    function initialize() initializer public {
        __ERC20_init("EventTicketToken", "TKT");
        // __Ownable_init();
        __UUPSUpgradeable_init();
    }

    function mint(address to, uint256 amount) public onlyOwner {
        
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        // onlyOwner
        // override
    {}

}

contract EventTicketManager {

    EventTicketToken public token;

    constructor() {
        token = new EventTicketToken();
    }
        
    function buyTicket() payable public {
        uint256 amountTobuy = msg.value;
        uint256 tokenBalance = token.balanceOf(address(this));
        require(amountTobuy > 0, "Can't be less than equal to 0");
        require(amountTobuy <= tokenBalance, "Tokens reserve insufficient");
        token.transfer(msg.sender, amountTobuy);
        // send event notification of this
    }

    function sellToken(uint256 amount) public {
        require(amount > 0, "Can't be less than equal to 0");
        token.approve(address(this), amount);
        payable(msg.sender).transfer(amount);
        // send event notification of this
    }

    function balanceOf(address account) external view returns (uint256) {
        return token.balanceOf(account);
    }

    function increaseAllowance(address spender, uint256 addedValue) public {
        // token.increaseAllowance(spender, addedValue);
    }
}

contract EventManager {
    struct Event {
        uint256 eventId;
        string eventName;
        uint256 maxSeats;
        uint256 availableSeats;
        uint256 ticketPrice;
        uint eventTimestamp;
        string eventDescription;
        bool cancelled;
        bool completed;
        bool[] seatMap;
    }

    mapping(uint256 => Event) public events;
    uint256[] private eventIdArray;

    constructor() {}

    function createEvent(
        uint256 _eventId, string memory _eventName, uint256 _maxSeats, uint256 _ticketPrice, uint timeDate, string memory _eventDescription)
         public returns (uint256) {     
        events[_eventId] = Event(_eventId, _eventName, _maxSeats, _maxSeats, _ticketPrice, timeDate, _eventDescription, false, false, new bool[](_maxSeats));
        eventIdArray.push(_eventId);
        return _eventId;
    }

    // write getters and setters

    function reserveSeats(uint256 _eventId, uint256 _numTickets, uint256[] memory _seatNumber) public {

    }
}

contract System is EventTicketManager, EventManager {
    
    // EventManager public eventManager;
    EventTicketToken public system;

    struct EventMetadata {
        uint256 bookingPayment;
        uint256 collectedAmount;
        address payable[] guestAddresses;
        mapping(address => uint256) ticketsOwned;   
    }

    mapping(uint256 => EventMetadata) public eventsMetadata;
    event NewEvent(uint256 eventId, string eventName, uint256 maxSeats, uint256 ticketPrice, uint eventTimestamp, string eventDescription, uint256 payment);
    event TicketPurchased(uint256 eventId, address buyer, uint256 numTickets);
    event TicketTransferred(uint256 eventId, address from, address to, uint256 numTickets);

    constructor() {
        system = new Ticket();
    }

    function createEvent(string memory _eventName, uint256 _maxSeats, uint256 _ticketPrice, uint eventTimestamp, string memory _eventDescription) public returns (uint256 _eventId) {
        require(token.balanceOf(msg.sender) >= bookingAmount, "Insufficient Balance");
        token.transferFrom(msg.sender, address(this), bookingAmount);
        _eventId = block.timestamp;
        eventsMetadata[_eventId].bookingPayment = bookingAmount;
        eventsMetadata[_eventId].guestAddresses = new address payable[](0);
        createEvent(_eventId, _eventName, _maxSeats, _ticketPrice, eventTimestamp, _eventDescription);
        // send event notification
        return _eventId;
    }

    function buyTickets(uint256 _eventId, uint256 _numTickets, uint256[] memory _seatNumber) public {
        uint256 ticketPrice = getTicketPrice(_eventId);
        uint256 bookingAmount = ticketPrice * _numTickets;
        // validate seat availability
        require(token.balanceOf(msg.sender) >= bookingAmount, "Insufficient Balance");
        token.transferFrom(msg.sender, address(this), bookingAmount);
        eventsMetadata[_eventId].ticketsBought[msg.sender] += _numTickets;
        eventsMetadata[_eventId].collectedAmount += bookingAmount;
        bookSeats(_eventId, _numTickets, _seatNumber);
        // send event notification
    }

    function cancelEvent(uint256 _eventId) public {
      
    }

    function refundTheAdvance(uint256 timeDate, uint256 _eventId) private {
       
    }

    function refundTicketAmount(uint256 ticketPrice, uint256 _eventId) private {
        
    }

    function completeEvent(uint256 _eventId) public {
     
    }

    function transferTickets(uint256 _eventId, address _to, uint256 _numTickets, uint256 _askedPrice) public {
       
    }
}