//  corsiDiStudio

import Foundation

enum CorsoDiStudio: String, CaseIterable, Identifiable, Codable {
    case faq = "FAQ"
    case agraria = "Agriculture"
    case architettura = "Architecture"
    case biotecnologie = "Biotechnology"
    case chimica = "Chemistry"
    case economia = "Economics"
    case farmacia = "Pharmacy"
    case fisica = "Physics"
    case giurisprudenza = "Law"
    case informatica = "Computer Science"
    case ingegneriaAerospace = "Aerospace Engineering"
    case ingegneriaBiomedica = "Biomedical Engineering"
    case ingegneriaChimica = "Chemical Engineering"
    case ingegneriaCivile = "Civil Engineering"
    case ingegneriaElettrica = "Electrical Engineering"
    case ingegneriaGestionale = "Management Engineering"
    case ingegneriaInformatica = "Computer Engineering"
    case ingegneriaMeccanica = "Mechanical Engineering"
    case ingegneriaNavale = "Naval Engineering"
    case ingegneriaTelecomunicazioni = "Telecommunications Engineering"
    case lettereFilosofia = "Arts and Philosophy"
    case matematica = "Mathematics"
    case medicina = "Medicine"
    case odontoiatria = "Dentistry"
    case psicologia = "Psychology"
    case scienzeBiologiche = "Biological Sciences"
    case scienzePolitiche = "Political Science"
    case sociologia = "Sociology"
    case statistica = "Statistics"
    case storia = "History"
    case veterinaria = "Veterinary Medicine"
    
    var id: Self { self }
    
    var imageName: String {
            switch self {
            case .faq: return "circle"
            case .agraria: return "leaf.circle"
            case .architettura: return "building.2.crop.circle"
            case .biotecnologie: return "flask"
            case .chimica: return "testtube.2"
            case .economia: return "chart.bar.doc.horizontal"
            case .farmacia: return "pills"
            case .fisica: return "atom"
            case .giurisprudenza: return "scroll"
            case .informatica: return "desktopcomputer"
            case .ingegneriaAerospace: return "airplane"
            case .ingegneriaBiomedica: return "heart.circle"
            case .ingegneriaChimica: return "drop.circle"
            case .ingegneriaCivile: return "building.2"
            case .ingegneriaElettrica: return "bolt.circle"
            case .ingegneriaGestionale: return "gearshape.2"
            case .ingegneriaInformatica: return "cpu"
            case .ingegneriaMeccanica: return "wrench.and.screwdriver"
            case .ingegneriaNavale: return "sailboat.circle"
            case .ingegneriaTelecomunicazioni: return "antenna.radiowaves.left.and.right"
            case .lettereFilosofia: return "book"
            case .matematica: return "function"
            case .medicina: return "stethoscope"
            case .odontoiatria: return "mouth" //non l'icon del dente
            case .psicologia: return "brain.head.profile"
            case .scienzeBiologiche: return "leaf"
            case .scienzePolitiche: return "flag.circle"
            case .sociologia: return "person.3"
            case .statistica: return "chart.bar"
            case .storia: return "clock"
            case .veterinaria: return "pawprint.circle"
            }
        }
}

