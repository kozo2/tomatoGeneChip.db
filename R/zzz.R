datacache <- new.env(hash=TRUE, parent=emptyenv())

tomatoGeneChip <- function() showQCData("tomatoGeneChip", datacache)
tomatoGeneChip_dbconn <- function() dbconn(datacache)
tomatoGeneChip_dbfile <- function() dbfile(datacache)
tomatoGeneChip_dbschema <- function(file="", show.indices=FALSE) dbschema(datacache, file=file, show.indices=show.indices)
tomatoGeneChip_dbInfo <- function() dbInfo(datacache)

tomatoGeneChipORGPKG <- "org.Slycopersicum.eg"
tomatoGeneChipORGANISM <- "Solanum lycopersicum"

.onLoad <- function(libname, pkgname)
{
    ## Connect to the SQLite DB
    dbfile <- system.file("extdata", "tomatoGeneChip.sqlite", package=pkgname, lib.loc=libname)
    assign("dbfile", dbfile, envir=datacache)
    dbconn <- dbFileConnect(dbfile)
    assign("dbconn", dbconn, envir=datacache)

    ## Create the OrgDb object
    sPkgname <- sub(".db$","",pkgname)
    db <- loadDb(system.file("extdata", paste(sPkgname,
      ".sqlite",sep=""), package=pkgname, lib.loc=libname),
                   packageName=pkgname)    
    dbNewname <- AnnotationDbi:::dbObjectName(pkgname,"ChipDb")
    ns <- asNamespace(pkgname)
    assign(dbNewname, db, envir=ns)
    namespaceExport(ns, dbNewname)
        
    packageStartupMessage(AnnotationDbi:::annoStartupMessages("tomatoGeneChip.db"))
}

.onUnload <- function(libpath)
{
    dbFileDisconnect(tomatoGeneChip_dbconn())
}

