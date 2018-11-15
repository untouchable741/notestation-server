//
//  NotesController.swift
//  App
//
//  Created by Huu Tai Vuong on 11/15/18.
//

import Foundation
import Vapor
import Fluent

final class NotesController {
    func list(_ req: Request) throws -> Future<[Note]> {
        let user = try req.requireAuthenticated(User.self)
        return try user.notes.query(on: req).all().map { notes in
            return notes
        }
    }
    
    func create(_ req: Request) throws -> Future<Note> {
        let user = try req.requireAuthenticated(User.self)
        return try req.content.decode(Note.NoteForm.self).flatMap { noteForm -> Future<Note> in
            let newNote = Note(id: nil,
                               title: noteForm.title,
                               content: noteForm.content,
                               userId: try user.requireID(),
                               createdAt: Date(),
                               updateAt: Date())
            return newNote.save(on: req)
            
        }
    }
    
    func update(_ req: Request) throws -> Future<Note> {
        let _ = try req.requireAuthenticated(User.self)
        let noteId = try req.parameters.next(Int.self)
        return try req.content.decode(Note.NoteForm.self).flatMap { noteForm -> Future<Note> in
            return Note.find(noteId, on: req).flatMap { note in
                guard var note = note else {
                    throw Abort(.badRequest)
                }
                note.title = noteForm.title
                note.content = noteForm.content
                note.updateAt = Date()
                return note.save(on: req)
            }
        }
    }
}
