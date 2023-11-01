setwd("G:/DEBI/Applied-DS-Project")
Sys.setenv("VROOM_CONNECTION_SIZE" = 131072 * 1000)

require("biomaRt")

probe_ids<-read.csv(file ='./ProbeIDs.csv')
head(probe_ids$ProbeID[1:5])


mart <- useMart("ENSEMBL_MART_ENSEMBL")
mart <- useDataset("hsapiens_gene_ensembl", mart)
annotLookup <- getBM(
  mart=mart,
  filter = "affy_hg_u133_plus_2",
  attributes=c('affy_hg_u133_plus_2', 'ensembl_gene_id','gene_biotype','external_gene_name','p_value'),
  values = probe_ids$ProbeID, uniqueRows=TRUE)

head(annotLookup, 20)

write.csv(annotLookup,"G:/DEBI/Mapping.csv", row.names = FALSE)


