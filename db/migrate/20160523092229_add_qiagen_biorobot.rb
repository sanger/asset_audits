class AddQiagenBiorobot < ActiveRecord::Migration
  ROBOT_BARCODE = "4880001006869"
  BEDS_CONFIG = {
     "P1" =>'4880001007873',
     "P2" =>'580000015865',
     "P3" =>'4880001008658',
     "P4" =>'4880001009662',
     "P5" =>'4880001010828'
   }

  NEW_BEDS = {
    "P6" => "580000016879",
    "P7" => "580000017654"
  }

  def self.up
    ActiveRecord::Base.transaction do
      # Rename Biorobot old process
      InstrumentProcess.find_by_name("Biorobot").update_attributes(:name => "QIAamp DNA BloodCard UNIV rcv237")

      # Creat new one
      instrument = Instrument.find_by_barcode!(ROBOT_BARCODE)
      instrument_process = InstrumentProcess.create! ({:name => "QIAamp pathogen vet UNIV_rcV226a", :key => "qiagen_biorobot",
        :request_instrument => true })
      instrument_processes_instrument = InstrumentProcessesInstrument.create! ({:instrument => instrument,
        :instrument_process => instrument_process, :bed_verification_type => "Verification::DilutionPlate::QiagenBiorobot"})
      Bed.create!({:name => "P6",
                   :bed_number => 6,
                   :barcode => NEW_BEDS["P6"],
                   :instrument => instrument})
      Bed.create!({:name => "P7",
                   :bed_number => 7,
                   :barcode => NEW_BEDS["P7"],
                   :instrument => instrument})
    end
  end

  def self.down
    ActiveRecord::Base.transaction do
      Bed.find_by_barcode(NEW_BEDS["P6"]).destroy
      Bed.find_by_barcode(NEW_BEDS["P7"]).destroy
      InstrumentProcess.find_by_name("QIAamp pathogen vet UNIV_rcV226a").destroy
      InstrumentProcess.find_by_name("QIAamp DNA BloodCard UNIV rcv237").update_attributes(:name => "Biorobot")
    end
  end
end
