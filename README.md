# From Conventional to IoT-Enhanced: Simulated Object-Centric Event Logs for Real-Life Logistics Processes

This repository contains the resources for the paper "From Conventional to IoT-Enhanced: Simulated Object-Centric Event Logs for Real-Life Logistics Processes". In this paper, we present two OCEL 2.0 logs, simulated using the CPN tool, which captures the cargo pickup process in one of the major ports in China. The first log represents the traditional cargo pickup process, encompassing multiple object types such as cargo, pickup plans, trucks, and silos. It also captures their static and dynamic relationships and their relationships with events. The second log builds upon the first by integrating IoT data, capturing the relationships between IoT objects and business objects, as well as between IoT objects and process events. This log details the intricate interactions between IoT devices and business processes. 

## Repository Structure:
### 1. Conventional_BP
#### object_initialise
Contains a CPN model for initialising objects involved in the process and a collection of CSV files. The resulting object tables for each type include both static and dynamic attributes, with dynamic attributes initially set to NULL or 0.0.
#### CargoPickupBP
Includes a CPN model for capturing the cargo pickup process and a collection of CSV files.
  - The resulting files include an object table for each object type, an event table for each event type, and E2O (Event-to-Object) and O2O (Object-to-Object) relations tables.
  - A _CSVs_to_OCEL_SQLITE.ipynb_: Details how to generate OCEL 2.0 logs using the _PM4PY_ package.
  - A _CargoPickup.sqlite_: The resulting OCEL log.
    
#### Simulation Instructions for Conventional Cargo Pickup Process
- Run the simulation on _object_initialisation.cpn_ in the **object_initialise** folder.
- Run the simulation on _truck_bp.cpn_ in the **CargoPickupBP** folder.
  

### 2. IoT-enhanced_BP
#### Random_data_generation.ipynb
Specifies the random generation of IoT data used in the IoT-enhanced cargo pickup process.
#### object_initialiser_iot
Contains a CPN model for initialising objects involved in the process incorporating IoT technologies and a collection of CSV files. The resulting object tables for each type include both static and dynamic attributes, with dynamic attributes initially set to NULL or 0.0.
#### truck_bp_iot
Features a CPN model for capturing the IoT-enhanced cargo pickup process and a collection of CSV files.
  - The resulting files include an object table for each object type, an event table for each event type, E2O (Event-to-Object) and O2O (Object-to-Object) relations tables, and an IoTDevice-to-Object(IoT2O) and IoTDevice-to-Event (IoT2E) IoTDevice-to-Event relation (IoT2E) table.
  - A _CSVs_to_OCEL_SQLITE.ipynb_: Details how to generate OCEL 2.0 logs using the _PM4PY_ package..
  - A _CargoPickup_IoT.sqlite_: The resulting OCEL log.
 
#### Simulation Instructions for IoT-enhanced Cargo Pickup Process
- Run _Random_data_generation.ipynb_ to generate the required IoT data.
- Run the simulation on _object_initialisation_iot.cpn_ in the **object_initialiser_iot** folder.
- Run the simulation on _truck_bp_iot.cpn_ in the **truck_bp_iot** folder.
