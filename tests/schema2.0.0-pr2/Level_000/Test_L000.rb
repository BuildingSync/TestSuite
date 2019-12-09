require "nokogiri/xml/schematron/schema"

dir = Dir.pwd + '/tests/Level_100/'
puts dir
file_out = dir + "BuildingSync_schematron_L100.xml"

EX_ONCE = "is REQUIRED EXACTLY ONCE"
RE = "is REQUIRED"
OPT = "is OPTIONAL"
NR = "is NOT RECOMMENDED"

BS = "auc:BuildingSync"
BS_CON = "/#{BS}"

FA_PL = "auc:Facilities"
FA_PL_CON = BS_CON + "/#{FA_PL}"

FA = "auc:Facility"
FA_CON = FA_PL_CON + "/#{FA}"

SI_PL = "auc:Sites"
SI_PL_CON = FA_CON + "/#{SI_PL}"

SI = "auc:Site"
SI_CON = SI_PL_CON + "/#{SI}"

BU_PL = "auc:Buildings"
BU_PL_CON = SI_CON + "/#{BU_PL}"

BU = "auc:Building"
BU_CON = BU_PL_CON + "/#{BU}"

schema = Nokogiri::XML::Schematron::Schema.new(title: "Level 100 schema") do
  ns(prefix: "auc", uri: "http://buildingsync.net/schemas/bedes-auc/2019")
  pattern(name: "BuildingSync Level 100") do
    rule(context: "/") do
      assert(test: "count(#{BS}) = 1", message: "element \"#{BS}\" #{EX_ONCE}")
    end
    rule(context: BS_CON) do
      assert(test: "count(#{FA_PL}) = 1", message: "element \"#{FA_PL}\" #{EX_ONCE}")
    end
    rule(context: FA_PL_CON) do
      assert(test: "count(#{FA}) = 1", message: "element \"#{FA}\" #{EX_ONCE}")
    end
    rule(context: FA_CON) do
      assert(test: "count(#{SI_PL}) = 1", message: "element \"#{SI_PL}\" #{EX_ONCE}")
    end
    rule(context: SI_PL_CON) do
      assert(test: "count(#{SI}) = 1", message: "element \"#{SI}\" #{EX_ONCE}")
    end
    rule(context: SI_CON) do
      assert(test: "count(auc:ClimateZoneType) = 1", message: "element \"auc:ClimateZoneType\" #{RE}")
    end
    rule(context: SI_CON) do
      assert(test: "count(#{BU_PL}) = 1", message: "element \"#{BU_PL}\" #{EX_ONCE}")
    end
    rule(context: SI_CON + "/auc:ClimateZoneType") do
      assert(test: "count(//auc:ClimateZone) = 1", message: "element \"auc:ClimateZone\" #{EX_ONCE}")
    end
    rule(context: BU_PL_CON) do
      assert(test: "count(#{BU}) = 1", message: "element \"#{BU}\" #{EX_ONCE}")
    end
  # TODO:
  # 1. check for measures, measure
  # 2. check for reports/report/scenarios/scenario ID="Baseline"
  # 3. check for bulding level things: BuildingClassification,
  #     OccupancyClassification, FloorsAboveGrade, ...
  end
end

io = File.open(file_out, "w+")

io.puts(schema.to_builder(encoding: "UTF-8").to_xml)