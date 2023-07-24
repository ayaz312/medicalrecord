// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

contract MedicalRecord {

    
    
    
    // node for doctorer rtecord
    struct Doctor{
        uint id;
        string name;
        string qualification;
        string workplace;
        bool Registered;
    }

    // node for patient record
    struct Patient{
        uint Id;
        string name;
        uint age;
        bytes disease;
        bool Registered;
       // bytes medicin_ids;
     }

     // node for medicin record
    struct Medicin{
        uint256 medicinid;
        string name;
        string dose;
        string expiryDate;
        uint price;
     }

     struct PrescribedMedicin{
        uint256 medicin_id;
        uint256 patient_id;
        
     }

    mapping(address => Doctor) doctors;
    mapping(address => Patient) patients;
    mapping(address => Medicin) medicins;
    mapping(uint256 => PrescribedMedicin) prescribedmedicins;

    Doctor[] doctor_record;
    Patient[] patient_record;
    Medicin[] medicin_record;
    PrescribedMedicin[] prescribed_medicin_record;

    modifier onlypatient{
        require(patients[msg.sender].Registered,"you are not registered");
        _;
    }

    modifier onlydoctor{
        require(doctors[msg.sender].Registered,"you are not registered");
        _;
    }

    uint doctor_id;
    uint patient_id;
    uint medicin_id;

    function registerDoctor(string memory _name, string memory _qualification, string memory _workPlace) public  {
        doctor_id++;
        doctors[msg.sender].id = doctor_id;
        doctors[msg.sender].name = _name;
        doctors[msg.sender].qualification = _qualification;
        doctors[msg.sender].workplace = _workPlace;
        doctors[msg.sender].Registered = true;
        
        
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
        //  medicin_ids = string(patients[msg.sender].medicin_ids);
        // patient_address = msg.sender;

    }

    // register patient
    function addMedicin(string memory _name , string memory  _dose , string memory _expiryDate,uint _price) public {
        Medicin storage medicin = medicins[msg.sender];
        medicin_id++;
        medicin.medicinid = medicin_id;
        medicin.dose = _dose;
        medicin.name = _name;
        medicin.expiryDate = _expiryDate;
        medicin.price = _price;
        medicin_record.push(medicins[msg.sender]);
        
    }




    // view medicin detail
    function viewMedicinDetail(uint _id) public view  returns(uint medicinid,string memory dose,string memory name,uint  price){

        for (uint i =0; i < medicin_record.length; i++) 
        {
            if(medicin_record[i].medicinid == _id) {
                return (medicin_record[i].medicinid,medicin_record[i].dose,medicin_record[i].name,medicin_record[i].price);
            }

        }
    }

    
   function addPrescribedMedicin(
        uint256 _medicinid,
        uint256 _patient_id
        
    ) public onlydoctor {
        prescribedmedicins[_patient_id].medicin_id = _medicinid;
        prescribedmedicins[_patient_id].patient_id = _patient_id;

        prescribed_medicin_record.push(prescribedmedicins[_patient_id]);
        
    }
    
    function queryPrescribedMedicinById(uint256 _patient_id) public view returns (uint id)
    {
       
       for (uint i =0; i < prescribed_medicin_record.length; i++) 
        {
            
            if(prescribed_medicin_record[i].patient_id == _patient_id) {
                
                     return prescribed_medicin_record[i].medicin_id;
            }
        }
        
    
    }

    

    }
