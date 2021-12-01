// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract EggVentas {
    
    struct dataSale {
        string email;
        uint256 date;
        bool isExist;
    }
    struct dataCourse {
        string _courseId;
        uint price;
    }
    struct priceStruct {
        uint price;
        bool isExist;
    }

    address public owner;
    dataCourse[] allCourses;
    mapping(address => mapping(string => dataSale)) private eggSales;
    mapping(string => priceStruct) private priceCourse;

    constructor() {
        owner = msg.sender;
    }
    
    function buyCourse(string memory email, string memory _courseId) public payable {
        require(priceCourse[_courseId].isExist, "The requested course does not exist");
        uint price = priceCourse[_courseId].price;
        require(!eggSales[msg.sender][_courseId].isExist, "You already bought this course");
        require(msg.value == price, "Please submit the asking price in order to complete the purchase");
        eggSales[msg.sender][_courseId].email = email;
        eggSales[msg.sender][_courseId].date = block.timestamp;
        eggSales[msg.sender][_courseId].isExist = true;
    }

    function editCourses(string memory _courseId, uint price) public {
        require(msg.sender == owner, "Access denied");
        if(!priceCourse[_courseId].isExist) {
            dataCourse memory curso;
            curso._courseId = _courseId;
            curso.price = price;
            allCourses.push(curso);
        }else{
            for(uint i; i < allCourses.length; i++) {
                if(keccak256(bytes(allCourses[i]._courseId)) == keccak256(bytes(_courseId))) {
                    allCourses[i].price = price;
                }
            }
        }
        priceCourse[_courseId].price = price;
        priceCourse[_courseId].isExist = true;
    }

    function getCoursePrice(string memory _courseId) public view returns (uint) {
        return priceCourse[_courseId].price;
    }

    function getAllCoursesPrice() public view returns (dataCourse[] memory) {
        return allCourses;
    }

    function getSale(address student, string memory _courseId) public view returns (dataSale memory) {
        return eggSales[student][_courseId];
    }

}
