//
//  CreateMajor.swift
//  UniLinkApp
//
//  Created by Francesco Paolo Severino on 10/12/24.
//

import Fluent

struct CreateMajor: AsyncMigration {
    func prepare(on database: any Database) async throws {
        _ = try await database.enum(Major.FieldKeys.enumName)
            .case(Major.faq.rawValue)
            .case(Major.agraria.rawValue)
            .case(Major.architettura.rawValue)
            .case(Major.biotecnologie.rawValue)
            .case(Major.chimica.rawValue)
            .case(Major.economia.rawValue)
            .case(Major.farmacia.rawValue)
            .case(Major.fisica.rawValue)
            .case(Major.giurisprudenza.rawValue)
            .case(Major.informatica.rawValue)
            .case(Major.ingegneriaAerospace.rawValue)
            .case(Major.ingegneriaBiomedica.rawValue)
            .case(Major.ingegneriaChimica.rawValue)
            .case(Major.ingegneriaCivile.rawValue)
            .case(Major.ingegneriaElettrica.rawValue)
            .case(Major.ingegneriaGestionale.rawValue)
            .case(Major.ingegneriaInformatica.rawValue)
            .case(Major.ingegneriaMeccanica.rawValue)
            .case(Major.ingegneriaNavale.rawValue)
            .case(Major.ingegneriaTelecomunicazioni.rawValue)
            .case(Major.lettereFilosofia.rawValue)
            .case(Major.matematica.rawValue)
            .case(Major.medicina.rawValue)
            .case(Major.odontoiatria.rawValue)
            .case(Major.psicologia.rawValue)
            .case(Major.scienzeBiologiche.rawValue)
            .case(Major.scienzePolitiche.rawValue)
            .case(Major.sociologia.rawValue)
            .case(Major.statistica.rawValue)
            .case(Major.storia.rawValue)
            .case(Major.veterinaria.rawValue)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.enum(Major.FieldKeys.enumName).delete()
    }
}

extension Major {
    enum FieldKeys {
        static let enumName = "major"
    }
}
