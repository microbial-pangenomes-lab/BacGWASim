
configfile: "ConfigFile.yaml"
ModuleDir = config['ModuleDir']

include: ModuleDir+'/ParamsPermutation/SimulationIndexDict.py'
include: ModuleDir+'/Assembler/Assembler_count.py'


rule all:
     input:
            #expand("{outputDIR}/{simulations}/{simulation_index}/ProteinCodingGene/{iteration}/ProtSim",outputDIR=config["outputDIR"],simulations=config["simulations"],simulation_index=simulation_index_dict.keys(),iteration=range(int(config['Protein_coding_gene_CatSize']))),
            #expand("{outputDIR}/{simulations}/{simulation_index}/IntergenicRegions/{iteration}/dawg.fas",outputDIR=config["outputDIR"],simulations=config["simulations"],simulation_index=simulation_index_dict.keys(),iteration=range(int(config['Intergenic_region_CatSize']))),
            #expand("{outputDIR}/{simulations}/{simulation_index}/RNAGene/{iteration}/dawg.fas",outputDIR=config["outputDIR"],simulations=config["simulations"],simulation_index=simulation_index_dict.keys(),iteration=range(int(config['RNA_gene_CatSize']))),
            #expand("{outputDIR}/{simulations}/{simulation_index}/Assembly/{name}.fsa",outputDIR=config["outputDIR"],simulations=config["simulations"],simulation_index=simulation_index_dict.keys(),name=names),
            #expand("{outputDIR}/{simulations}/{simulation_index}/PhenotypeSim/{phenotype_index}/CausalLoci.snplist",outputDIR=config["outputDIR"],simulations=config["simulations"],simulation_index=simulation_index_dict.keys(),phenotype_index=config['causal_variant_Num'].split(',')),
            expand("{outputDIR}/{SequenceDIR}/{fasta_output}.sa",outputDIR=config["outputDIR"],SequenceDIR=config["SequenceDIR"],fasta_output=str(config["fasta_file"]).split('/')[-1]),
            expand("{outputDIR}/{simulations}/{simulation_index}/PhenotypeSim/{phenotype_index}/gatc.par",outputDIR=config["outputDIR"],simulations=config["simulations"],simulation_index=simulation_index_dict.keys(),phenotype_index=config['causal_variant_Num'].split(',')),
            expand("{outputDIR}/{simulations}/{simulation_index}/PhenotypeSim/PlinkFormatReport.imiss",outputDIR=config["outputDIR"],simulations=config["simulations"],simulation_index=simulation_index_dict.keys()),
            expand("{outputDIR}/{simulations}/{simulation_index}/PhenotypeSim/PlinkFormatCausalVar.imiss",outputDIR=config["outputDIR"],simulations=config["simulations"],simulation_index=simulation_index_dict.keys()),
            expand("{outputDIR}/{simulations}/{simulation_index}/VarCall/Haploview.LD.PNG",outputDIR=config["outputDIR"],simulations=config["simulations"],simulation_index=simulation_index_dict.keys()),

include: ModuleDir+'/Sequences/Sequences.snake',
include: ModuleDir+'/ParamsPermutation/ParamPermuterPG.snake'
include: ModuleDir+'/ParamsPermutation/ParamPermuterIR.snake'
include: ModuleDir+'/ParamsPermutation/ParamPermuterRG.snake'
include: ModuleDir+'/ParamsPermutation/ParamPermuterRR.snake'
include: ModuleDir+'/Simulator/SimulatorPG.snake'
include: ModuleDir+'/Simulator/SimulatorIR.snake'
include: ModuleDir+'/Simulator/SimulatorRG.snake'
include: ModuleDir+'/Simulator/SimulatorRR.snake'
include: ModuleDir+'/Assembler/AssemblerGenome.snake'
include: ModuleDir+'/NGSsim/NGSsimPaired.snake'
include: ModuleDir+'/Indexer/BWAindexer.snake'
include: ModuleDir+'/Aligner/AlignerPaired.snake'
include: ModuleDir+'/SamToBam/SamToBam.snake' #Use picard to sort, markduplicate, convert and index the sam alignments generated by BWA
include: ModuleDir+'/SamToBam/BamMapQfilter.snake' #Filter out the mapped reads with MapQ score of <20, for better variant calling
include: ModuleDir+'/SamToBam/BamIndexer.snake'    #To index the filterd bam files to be used by GATK
include: ModuleDir+'/VarCall/vcfCaller.snake' #GATK haplotype caller for single sample variant calling
include: ModuleDir+'/VarCall/vcfZipIndexer.snake' # Convert multiallelic variants into biallelic required by plink and index the variants
include: ModuleDir+'/VarCall/CombinedVCFcaller.snake' #Convert single-sample variant calls by haplotype caller into multi-sample 
include: ModuleDir+'/PhenotypeSim/BCFConverter2.snake' #Filter and format results of single-sample variant calling by GATK 
include: ModuleDir+'/PhenotypeSim/PlinkConverter.snake'
include: ModuleDir+'/PhenotypeSim/GenotypeRateReporter.snake' #Reporting the variant calling QC report using PLINK. If we used haplotypecaller and assume all the sites have enough coverage which is our assumption for multi-sample calling, then there is no missing genotype and this step will be Non-informative.
include: ModuleDir+'/PhenotypeSim/PhenoPermutor.snake'
include: ModuleDir+'/PhenotypeSim/PhenoSim.snake'
include: ModuleDir+'/LDPlotter/LDPlotter.snake'


