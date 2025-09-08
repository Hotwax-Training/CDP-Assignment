-------------------------------------------------------
-- Customer Data Access Logic (Pseudo-code)
-------------------------------------------------------

-------------------------------------------------------
-- 1. CREATE NEW CUSTOMER
-------------------------------------------------------
function createCustomer(inputData):
    # Validate mandatory fields
    if inputData.firstName is empty OR inputData.email is empty:
        return error("Missing required fields: firstName or email")

    if not isValidEmail(inputData.email):
        return error("Invalid email format")

    # Create Party record of type PERSON
    partyId = create("Party", {
        partyTypeId: "PERSON",
        statusId: "PARTY_ENABLED",
        createdDate: now(),
        externalId: inputData.externalId
    })

    # Create Person record
    create("Person", {
        partyId: partyId,
        firstName: inputData.firstName,
        lastName: inputData.lastName,
        birthDate: inputData.birthDate,
        gender: inputData.gender
    })

    # Create ContactMech for email
    emailId = create("ContactMech", {
        contactMechTypeId: "EMAIL_ADDRESS",
        infoString: inputData.email
    })

    # Link Party to Email ContactMech
    create("PartyContactMech", {
        partyId: partyId,
        contactMechId: emailId,
        fromDate: now()
    })

    return success("Customer created", partyId)


-------------------------------------------------------
-- 2. RETRIEVE CUSTOMER
-------------------------------------------------------
function getCustomer(partyId):
    # Find Party record
    party = find("Party").where(partyId == partyId).one()
    if not party:
        return error("Customer not found")

    # Get Person details
    person = find("Person").where(partyId == partyId).one()

    # Get ContactMechs (active only)
    contacts = find("PartyContactMech")
                .where(partyId == partyId AND thruDate is null)
                .list()

    # Build customer object
    customer = {
        party: party,
        person: person,
        contactMechs: contacts,
        preferences: preferences
    }

    return success(customer)


-------------------------------------------------------
-- 3. UPDATE CUSTOMER
-------------------------------------------------------
function updateCustomer(partyId, updatedData):
    # Verify existence
    existingParty = find("Party").where(partyId == partyId).one()
    if not existingParty:
        return error("Customer not found")

    # Update Person details if provided
    if updatedData.firstName OR updatedData.lastName OR updatedData.birthDate:
        update("Person")
            .where(partyId == partyId)
            .set(firstName = updatedData.firstName,
                 lastName = updatedData.lastName,
                 birthDate = updatedData.birthDate)

    # Update Email
    if updatedData.email:
        # Expire old email
        update("PartyContactMech")
            .where(partyId == partyId AND thruDate is null)
            .set(thruDate = now())

        # Create new email contact
        newEmailId = create("ContactMech", {
            contactMechTypeId: "EMAIL_ADDRESS",
            infoString: updatedData.email
        })
        create("PartyContactMech", {
            partyId: partyId,
            contactMechId: newEmailId,
            fromDate: now()
        })

    # Update Address if provided (similar to email)
    if updatedData.address:
        expire old address
        create new ContactMech + PartyContactMech

    return success("Customer updated successfully", partyId)


-------------------------------------------------------
-- 4. DELETE CUSTOMER
-------------------------------------------------------
function deleteCustomer(partyId):
    # Verify existence
    customer = find("Party").where(partyId == partyId).one()
    if not customer:
        return error("Customer not found")

    # delete: mark disabled instead of permanent delete
    update("Party")
        .where(partyId == partyId)
        .set(statusId = "PARTY_DISABLED")

    # Expire active contact mechanisms
    update("PartyContactMech")
        .where(partyId == partyId AND thruDate is null)
        .set(thruDate = now())

    return success("Customer deleted successfully", partyId)
