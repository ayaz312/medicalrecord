// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

contract MedicalRecord {

    struct Doctor{
        uint id;
        string name;
        string qualification;
        string workplace;
        bool registered;
    }

    // add node for patient 
    struct Patient{
        uint Id;
        string name;
        uint age;
        bytes disease;
        bool Registered;
     }

    mapping(address => Doctor) doctors;
    mapping(address => Patient) patients;

    Doctor[] doctor_record;
    Patient[] patient_record;

    modifier onlypatient{
        require(patients[msg.sender].Registered,"you are not registered");
        _;
    }

    uint doctor_id;
    uint patient_id;

    function registerDoctor(string memory _name, string memory _qualification, string memory _workPlace) public  {
        doctor_id++;
        doctors[msg.sender].id = doctor_id;
        doctors[msg.sender].name = _name;
        doctors[msg.sender].qualification = _qualification;
        doctors[msg.sender].workplace = _workPlace;
        doctor_record.push(doctors[msg.sender]);
    }
function viewDoctorById(uint _id) public view returns(uint id, string memory name, string memory qualification, string memory workplace) {
        
        for (uint i =0; i < doctor_record.length; i++) 
        {
            if(doctor_record[i].id == _id) {
                return (doctor_record[i].id, doctor_record[i].name, doctor_record[i].qualification, doctor_record[i].workplace);
            }

        }
    }

    // register patient
    function registerPatient(string memory _name,uint _age) public {
        Patient storage patient = patients[msg.sender];
        patient_id++;
        patient.Id = patient_id;
        patient.name = _name;
        patient.age = _age;
        patient.Registered = true;
        patient_record.push(patients[msg.sender]);
    }

    // add disease only by patient
    function addNewDisease(string memory _disease) public onlypatient{

        string memory init = string(patients[msg.sender].disease);
        init = string(abi.encodePacked(init,", "));
        patients[msg.sender].disease = abi.encodePacked(init,_disease);
        patient_record[patients[msg.sender].Id - 1].disease = abi.encodePacked(init,_disease);

    }

    // update patient age
    function updateAge(uint _age) public onlypatient{

        patients[msg.sender].age = _age;
        patient_record[patients[msg.sender].Id - 1].age = _age;

    }
    // view
    function viewRecord() public view onlypatient returns(uint id,uint age,string memory name,string memory disease){

         id = patients[msg.sender].Id;
         age = patients[msg.sender].age;
         name = patients[msg.sender].name;
         disease = string(patients[msg.sender].disease);

    }




}
