// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

contract StudentRegistry {
    struct Student {
        string name;
        uint256 studentId;
        bool enrolled;
    }



    mapping(address => Student) private students;
    uint256 private nextStudentId;



    event Registered(address indexed studentAddress, uint256 studentId, string name);
    event Graduated(address indexed studentAddress, uint256 studentId);



    modifier onlyNotRegistered() {
        require(!students[msg.sender].enrolled, "Student is already registered");
        _;
    }

    modifier onlyRegistered() {
        require(students[msg.sender].enrolled, "Student is not registered");
        _;
    }




    function register(string memory _name) external onlyNotRegistered {
        students[msg.sender] = Student({
            name: _name,
            studentId: nextStudentId++,
            enrolled: true
        });
        emit Registered(msg.sender, students[msg.sender].studentId, _name);
    }

    function graduate() external onlyRegistered {
        students[msg.sender].enrolled = false;
        emit Graduated(msg.sender, students[msg.sender].studentId);
    }

   
}